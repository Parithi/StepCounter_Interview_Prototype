//
//  Extensions.swift
//  StepCounter
//
//  Created by ElamParithi Arul on 2020-06-23.
//  Copyright © 2020 Parithi Network. All rights reserved.
//

import UIKit
import SDWebImage

func getString(key : String) -> String {
    return NSLocalizedString(key, comment: "")
}

extension Date {
    
    func toGenericString() -> String {
        let df = DateFormatter()
        df.dateFormat = "MMM d"
        return df.string(from: self)
    }
    
}

extension UIView {
    
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
    
    func addBorder(width : CGFloat, color : UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    public func hide(completionDelegate : AnyObject? = nil){
        self.isHidden = true
    }
    
    public func show(completionDelegate : AnyObject? = nil){
        self.isHidden = false
    }
    
    public func makeRounded(radius: CGFloat? = nil) {
        let radius = radius ?? self.frame.height/2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    public func addShadowWithRadius(cornerRadius : CGFloat? = nil, shadowColor : UIColor = UIColor.black, shadowOpacity : Float = 0.2, shadowOffsetX : Int = 0, shadowOffsetY : Int = 4, shadowRadius : CGFloat = 5, scale: Bool = true, usePlainShadow : Bool = true){
        
        let radius = cornerRadius ?? self.frame.height/2
        
        makeRounded(radius: radius)
        
        if(!usePlainShadow) {
            self.layer.shadowPath =
                UIBezierPath(roundedRect: self.bounds,
                             cornerRadius: self.layer.cornerRadius).cgPath
        }
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = CGSize(width: shadowOffsetX, height: shadowOffsetY)
        self.layer.shadowRadius = shadowRadius
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
        self.layer.masksToBounds = false
    }
    
    fileprivate struct AssociatedObjectKeys {
        static var tapGestureRecognizer = "tapGestureRecognizer_Key"
    }
    
    fileprivate typealias Action = (() -> Void)?
    
    fileprivate var tapGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
            return tapGestureRecognizerActionInstance
        }
    }
    
    public func addTapGestureRecognizer(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
        if let action = self.tapGestureRecognizerAction {
            action?()
        }
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UILabel {
    
    func roundedFont(fontSize : CGFloat? = nil, weight : UIFont.Weight? = nil) {
        let fontSize = fontSize ?? self.font.pointSize
        let systemFont = UIFont.systemFont(ofSize: fontSize, weight: weight ?? .regular)
        if let descriptor = systemFont.fontDescriptor.withDesign(.rounded) {
            self.font = UIFont(descriptor: descriptor, size: fontSize)
        }
    }
    
}

extension UIButton {
    
    func addTouchAction(to action: Selector, viewController : UIViewController) {
        self.addTarget(viewController, action: action, for: .touchUpInside)
    }
    
}

extension UIViewController {
    
    func setAsRootVC(to window: UIWindow?) {
        guard let window = window else { return }
        window.rootViewController = self
        window.makeKeyAndVisible()
    }
    
}

extension UIImageView {
    
    public func imageFromUserId(userId : String?) {
        guard userId != nil else { return }
        FirebaseHelper.shared.getProfileInfoFor(userId : userId!) { userInfo in
            guard let userInfo = userInfo else { return }
            DispatchQueue.main.async {
                self.imageFromURL(urlString: userInfo.profilePictureUrl)
            }
        }
    }
    
    public func imageFromURL(urlString: String?, completionHandler : @escaping () -> () = {  }) {
        self.backgroundColor = UIColor.primary
        guard let urlString = urlString else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.sd_imageTransition = .fade
            self.sd_setImage(with: URL(string: urlString)) { image,error,_,_ in
                completionHandler()
            }
        }
    }
    
}
