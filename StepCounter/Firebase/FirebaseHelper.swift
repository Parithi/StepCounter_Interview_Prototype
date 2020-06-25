//
//  FirebaseHelper.swift
//  StepCounter
//
//  Created by ElamParithi Arul on 2020-06-23.
//  Copyright © 2020 Parithi Network. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

// Helper class for Firebase
class FirebaseHelper {
    
    var db: Firestore!

    static let shared = FirebaseHelper()
    
    private init() {
        Firestore.firestore().settings = FirestoreSettings()
        db = Firestore.firestore()
    }
    
    func createUser(user : User, completion : @escaping () -> Void) {
        FirebaseHelper.shared.getProfileInfoFor(userId: user.uid, useCache: false) { [weak self] profile in
            guard profile == nil else { completion(); return }
            let name = user.email?.components(separatedBy: "@")[0] ?? ""
            let email = user.email ?? ""
            let lastLoggedIn = Int64(Date().timeIntervalSince1970)
            
            var newUser = Profile()
            newUser.profilePictureUrl = String(format: Constants.AVATAR_URL, user.uid)
            newUser.email = email
            newUser.name = name
            newUser.lastLoggedIn = lastLoggedIn
            
            self?.setProfileData(id: user.uid, profile: newUser)
            completion()
        }
    }

    func getProfileInfoFor(userId : String, useCache : Bool = true, completion : @escaping (Profile?) -> ()) {
        if let userData = FirebaseCache.shared.profileCache[userId], useCache {
            completion(userData)
        } else {
            let userRef = db.collection(Collections.profiles.rawValue).document(userId)
            userRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let profile = try? document.data(as: Profile.self)
                    FirebaseCache.shared.profileCache[userId] = profile
                    completion(profile)
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    func setProfileData(id : String, profile : Profile) {
        FirebaseCache.shared.profileCache[id] = profile
        try? db.collection(Collections.profiles.rawValue).document(id).setData(from: profile)
    }

}

class FirebaseCache {
    static var shared = FirebaseCache()
    var profileCache : [String : Profile] = [:]
}
