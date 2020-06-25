//
//  ViewController.swift
//  StepCounter
//
//  Created by ElamParithi Arul on 2020-06-23.
//  Copyright © 2020 Parithi Network. All rights reserved.
//

import UIKit
import GoogleSignIn
import AuthenticationServices
import TinyConstraints

class LoginViewController: UIViewController {

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = getString(key: "app_name")
        label.textAlignment = .center
        label.textColor = .darkGray
        label.roundedFont(fontSize: 36, weight: .bold)
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "shoes")
        return imageView
    }()
    
    lazy var googleSignInButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "google_icon"), for: .normal)
        button.setTitle(getString(key: "sign_in_with_google"), for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.roundedFont(weight: .semibold)
        button.showsTouchWhenHighlighted = true
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        return button
    }()
    
    lazy var appleSignInButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "apple_icon"), for: .normal)
        button.setTitle(getString(key: "sign_in_with_apple"), for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.roundedFont(weight: .semibold)
        button.showsTouchWhenHighlighted = true
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        return button
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        view.backgroundColor = .primary
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(didLogin(_:)), name: .didLogin, object: nil)
    }
    
    @objc func didLogin(_ notification:Notification) {
        DashboardViewController().setAsRootVC(to: self.view.window)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupViews() {
        addLogo()
        addTitle()
        addLoginButtons()
    }
    
    private func addLogo() {
        view.addSubview(imageView)
        imageView.centerInSuperview()
        imageView.addTapGestureRecognizer { [weak self] in
            self?.imageView.shake()
        }
    }
    
    private func addTitle() {
        view.addSubview(titleLabel)
        titleLabel.topToSuperview(offset: 16)
        titleLabel.bottomToTop(of: imageView, offset: -16)
        titleLabel.leftToSuperview()
        titleLabel.rightToSuperview()
    }
    
    private func addLoginButtons() {
        view.addSubview(googleSignInButton)
        view.addSubview(appleSignInButton)
        
        appleSignInButton.leftToSuperview(offset: 16)
        appleSignInButton.rightToSuperview(offset: -16)
        
        googleSignInButton.leftToSuperview(offset: 16)
        googleSignInButton.rightToSuperview(offset: -16)
        
        appleSignInButton.height(54)
        googleSignInButton.height(54)
        
        appleSignInButton.centerXToSuperview()
        appleSignInButton.bottomToSuperview(offset: -16)
        
        googleSignInButton.centerXToSuperview()
        googleSignInButton.bottomToTop(of: appleSignInButton, offset: -16)
        
        view.layoutIfNeeded()
        
        googleSignInButton.addShadowWithRadius()
        appleSignInButton.addShadowWithRadius()

        googleSignInButton.addTouchAction(to: #selector(googleSignInPressed), viewController: self)
        appleSignInButton.addTouchAction(to: #selector(appleSignInPressed), viewController: self)

    }
    
    @objc func googleSignInPressed(sender: UIButton!) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @objc func appleSignInPressed(sender: UIButton!) {
        let nonce = AppleSignInHelper.randomNonceString()
        AppleSignInHelper.currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = AppleSignInHelper.sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = (UIApplication.shared.delegate as! ASAuthorizationControllerDelegate)
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
}

extension LoginViewController : ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

