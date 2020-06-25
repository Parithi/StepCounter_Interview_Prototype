//
//  DashboardViewController.swift
//  StepCounter
//
//  Created by ElamParithi Arul on 2020-06-23.
//  Copyright © 2020 Parithi Network. All rights reserved.
//

import UIKit
import FirebaseAuth

class DashboardViewController: UIViewController {
    
    let REQUIRED_STEP_COUNT : Double = 4000
    
    lazy var profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var salutationTextView : UILabel = {
        let textView = UILabel()
        textView.textColor = .black
        textView.roundedFont(fontSize: 18, weight: .semibold)
        return textView
    }()
    
    lazy var dataContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var errorMessageView : UILabel = {
        let textView = UILabel()
        textView.textColor = .lightGray
        textView.numberOfLines = 0
        textView.textAlignment = .center
        textView.roundedFont(fontSize: 16, weight: .regular)
        return textView
    }()
    
    lazy var stepDetailsTableView : UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection = false
        tableView.backgroundColor = .white
        return tableView
    }()
    
    fileprivate var userId : String!
    fileprivate var stepCountDetails : [StepData] = []
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let user = Auth.auth().currentUser else { return }
        userId = user.uid
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .primary
        addProfilePicture()
        addSalutation()
        addDataContainer()
        addTableView()
        addErrorMessageView()
        fillData()
    }
    
    private func addProfilePicture() {
        view.addSubview(profileImageView)
        profileImageView.topToSuperview(offset: 16, usingSafeArea: true)
        profileImageView.rightToSuperview(offset: -16)
        profileImageView.height(48)
        profileImageView.width(48)
        profileImageView.addBorder(width: 4, color: UIColor.white.withAlphaComponent(0.8))
        profileImageView.makeRounded(radius: 24)
        profileImageView.imageFromUserId(userId: userId)
        profileImageView.addTapGestureRecognizer { [weak self] in
            self?.showLogout()
        }
    }
    
    private func addSalutation() {
        view.addSubview(salutationTextView)
        salutationTextView.centerY(to: profileImageView)
        salutationTextView.leftToSuperview(offset: 16)
        salutationTextView.text = "Hello!"
    }
    
    private func addDataContainer() {
        view.addSubview(dataContainerView)
        dataContainerView.topToSuperview(offset: 82, usingSafeArea: true)
        dataContainerView.leftToSuperview()
        dataContainerView.bottomToSuperview(offset: 16)
        dataContainerView.rightToSuperview()
        dataContainerView.addShadowWithRadius(cornerRadius: 16)
    }
    
    private func addErrorMessageView() {
        dataContainerView.addSubview(errorMessageView)
        errorMessageView.centerYToSuperview()
        errorMessageView.leftToSuperview(offset: 36)
        errorMessageView.rightToSuperview(offset: -36)
    }
    
    private func addTableView() {
        dataContainerView.addSubview(stepDetailsTableView)
        stepDetailsTableView.register(StepCountTableViewCell.self, forCellReuseIdentifier: String(describing: StepCountTableViewCell.self))
        let padding : CGFloat = 8
        stepDetailsTableView.edgesToSuperview(insets: UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding))
        stepDetailsTableView.separatorStyle = .none
        stepDetailsTableView.showsVerticalScrollIndicator = false
        stepDetailsTableView.makeRounded(radius: 16)
        stepDetailsTableView.delegate = self
        stepDetailsTableView.dataSource = self
    }
    
    private func fillData() {
        HealthKitHelper.authorize { [weak self] status, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if (error != nil || status == false) {
                    self.errorMessageView.text = getString(key: "unable_to_get_data")
                } else {
                    self.showStepData()
                }
            }
        }
        
        FirebaseHelper.shared.getProfileInfoFor(userId: userId) { [weak self] profileInfo in
            guard let self = self else { return }
            guard let profileInfo = profileInfo, let name = profileInfo.name else { return }
            self.salutationTextView.text = String(format: getString(key: "salutation_label"), name)
        }
    }
    
    private func showLogout() {
        let alert = UIAlertController(title: getString(key: "logout_label"), message: getString(key: "logout_message"), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: getString(key: "cancel_label"), style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: getString(key: "logout_label"), style: .destructive, handler: { [weak self] action in
            try? Auth.auth().signOut()
            LoginViewController().setAsRootVC(to: self?.view.window)
            self?.dismiss(animated: false)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showStepData() {
        HealthKitHelper.fetchStepDetails() { [weak self] stepData in
            guard let self = self else { return }
            guard let stepData = stepData else { return }
            DispatchQueue.main.async {
                self.stepCountDetails.insert(stepData, at: 0)
                self.stepDetailsTableView.beginUpdates()
                self.stepDetailsTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                self.stepDetailsTableView.endUpdates()
            }
        }
    }
}

extension DashboardViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stepCountDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let stepData = stepCountDetails[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing:StepCountTableViewCell.self)) as! StepCountTableViewCell
        let stepCount = stepData.stepCount
        let percentage = stepCount / REQUIRED_STEP_COUNT
        cell.setData(stepCount : String(Int(stepCount)),
                     date: stepData.date.toGenericString(),
                     percentage : percentage,
                     isToday: Calendar.current.isDateInToday(stepData.date))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
