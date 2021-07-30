//
//  AuthViewController.swift
//  BusinessCards
//
//  Created by Douglas Webster on 7/29/21.
//

import Foundation
import UIKit
import Firebase

class AuthViewController: UIViewController {
    
    var delegate: UserAuthDelegate?
    
    enum AuthViewControllerState {
        case signIn
        case signUp
    }
    
    private var currentState: AuthViewControllerState = .signIn
    
    private var currentStackView: UIStackView?
    
    private let buttonWidthScale: CGFloat = 0.6
    private let textFieldWidthScale: CGFloat = 0.9
    private let stackPadding: CGFloat = 12
    private let stackContentPadding: CGFloat = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Theme.backgroundColor
        self.view.addSubview(logo)
        self.currentStackView = signInStackView
        self.view.addSubview(signInStackView)
    }
    
    override func viewDidLayoutSubviews() {
        let bounds = self.view.bounds
        
        let contentWidth = min(bounds.width * 0.8, 300)
        var contentFrame = CGRect.zero
        contentFrame.origin.x = bounds.midX - contentWidth/2.0
        contentFrame.origin.y = bounds.midY/2.0
        contentFrame.size.width = contentWidth
        
        let logoSize = logo.intrinsicContentSize
        logo.frame.origin.x = contentFrame.midX - (logoSize.width/2.0)
        logo.frame.origin.y = contentFrame.minY
        
        let padding: CGFloat = 20
        let logoOffset = logoSize.height + padding
        contentFrame.origin.y += logoOffset
        contentFrame.size.height += logoOffset
        
        if let stackView = currentStackView {
            let stackViewSize = stackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            var stackViewFrame = CGRect.zero
            stackViewFrame.origin.x = contentFrame.midX - (contentWidth/2.0)
            stackViewFrame.origin.y = contentFrame.minY
            stackViewFrame.size.width = contentWidth
            stackViewFrame.size.height = stackViewSize.height
            stackView.frame = stackViewFrame
            stackView.alpha = 1.0
        }
    }
   
    private lazy var logo: UIImageView = {
        let image = UIImage(named: "Icon")!
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    // MARK: - Sign In Components
    
    private lazy var signInErrorLabel: UILabel = {
        let label = Theme.getErrorLabel()
        return label
    }()
    
    private lazy var signInEmailTextField: UITextField = {
        let placeholder = NSLocalizedString("Email", comment: "")
        let textField = Theme.getTextField(placeholder: placeholder)
        return textField
    }()
    
    private lazy var signInPasswordTextField: UITextField = {
        let placeholder = NSLocalizedString("Password", comment: "")
        let textField = Theme.getTextField(placeholder: placeholder)
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var attemptSignInButton: UIButton = {
        let placeholder = NSLocalizedString("Sign In", comment: "")
        let button = Theme.getButton(title: placeholder)
        button.backgroundColor = Theme.keyColor
        button.setTitleColor(.clear, for: .disabled)
        button.addTarget(self, action: #selector(attemptSignIn), for: .touchUpInside)
        return button
    }()
    
    private lazy var switchToSignUpButton: UIButton = {
        let placeholder = NSLocalizedString("Need to sign up?", comment: "")
        let button = UIButton(type: .system)
        button.setTitle(placeholder, for: .normal)
        button.setTitleColor(Theme.subtleTextColor, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .footnote)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Sign Up Components
    
    private lazy var signUpErrorLabel: UILabel = {
        let label = Theme.getErrorLabel()
        return label
    }()
    
    private lazy var signUpFirstNameTextField: UITextField = {
        let placeholder = NSLocalizedString("First Name", comment: "")
        let textField = Theme.getTextField(placeholder: placeholder)
        return textField
    }()
    
    private lazy var signUpLastNameTextField: UITextField = {
        let placeholder = NSLocalizedString("Last Name", comment: "")
        let textField = Theme.getTextField(placeholder: placeholder)
        return textField
    }()
    
    private lazy var signUpEmailTextField: UITextField = {
        let placeholder = NSLocalizedString("Email", comment: "")
        let textField = Theme.getTextField(placeholder: placeholder)
        return textField
    }()
    
    private lazy var signUpPasswordTextField: UITextField = {
        let placeholder = NSLocalizedString("Password", comment: "")
        let textField = Theme.getTextField(placeholder: placeholder)
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var attemptSignUpButton: UIButton = {
        let placeholder = NSLocalizedString("Sign Up", comment: "")
        let button = Theme.getButton(title: placeholder)
        button.backgroundColor = Theme.keyColor
        button.setTitleColor(.clear, for: .disabled)
        button.addTarget(self, action: #selector(attemptSignUp), for: .touchUpInside)
        return button
    }()
    
    private lazy var switchToSignInButton: UIButton = {
        let placeholder = NSLocalizedString("Already have an account?", comment: "")
        let button = UIButton(type: .system)
        button.setTitle(placeholder, for: .normal)
        button.setTitleColor(Theme.subtleTextColor, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .footnote)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.addTarget(self, action: #selector(signInButtonPressed), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Stackviews
    
    private lazy var signInStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(self.signInErrorLabel)
        stackView.addArrangedSubview(self.signInEmailTextField)
        stackView.addArrangedSubview(self.signInPasswordTextField)
        stackView.addArrangedSubview(self.attemptSignInButton)
        stackView.addArrangedSubview(self.switchToSignUpButton)
        self.configure(stackView)
        return stackView
    }()
    
    private lazy var signUpStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(self.signUpErrorLabel)
        stackView.addArrangedSubview(self.signUpFirstNameTextField)
        stackView.addArrangedSubview(self.signUpLastNameTextField)
        stackView.addArrangedSubview(self.signUpEmailTextField)
        stackView.addArrangedSubview(self.signUpPasswordTextField)
        stackView.addArrangedSubview(self.attemptSignUpButton)
        stackView.addArrangedSubview(self.switchToSignInButton)
        self.configure(stackView)
        return stackView
    }()
    
}

extension AuthViewController {
    
    // MARK: - Attempt Sign In
    
    @objc private func attemptSignIn() {
        if let email = signInEmailTextField.text, !email.isEmpty,
           let password = signInPasswordTextField.text, !password.isEmpty {
            AuthProvider.signIn(email: email, password: password) { [weak self] (result) in
                guard let strongSelf = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .success(let user):
                        strongSelf.delegate?.updateUser(strongSelf, user: user, animated: true)
                    case .failure(let error):
                        let errorString = AuthError.errorString(for: error)
                        strongSelf.setSignInError(errorString)
                    }
                }
                
            }
        } else {
            let needsEmail = (signInEmailTextField.text ?? "").isEmpty
            let needsPassword = (signInPasswordTextField.text ?? "").isEmpty
            let authError: AuthError
            if needsEmail {
                authError = .missingEmail
            } else if needsPassword {
                authError = .missingPassword
            } else {
                authError = .unknown
            }
            let errorString = AuthError.errorString(for: authError)
            self.setSignInError(errorString)
        }
    }
    
    // MARK: - Attempt Sign Up
    
    @objc private func attemptSignUp() {
        let firstNameText = signUpFirstNameTextField.text ??  ""
        let firstName = firstNameText.trimWhitespace()
        let lastNameText = signUpLastNameTextField.text ?? ""
        let lastName = lastNameText.trimWhitespace()
        let emailText = signUpEmailTextField.text ?? ""
        let email = emailText.trimWhitespace()
        
        if !firstName.isBlank,
           !lastName.isBlank,
           !email.isBlank,
           let password = signUpPasswordTextField.text, !password.isBlank {
            AuthProvider.signUp(firstName: firstName, lastName: lastName, email: email, password: password, completionHandler: { [weak self] (result) in
                guard let strongSelf = self else { return }
                switch result {
                case .success(let user):
                    strongSelf.delegate?.updateUser(strongSelf, user: user, animated: true)
                case .failure(let error):
                    let errorString = AuthError.errorString(for: error)
                    strongSelf.setSignUpError(errorString)
                }
            })
        } else {
            let needsFirstName = (signUpFirstNameTextField.text ?? "").trimWhitespace().isBlank
            let needsLastName = (signUpLastNameTextField.text ?? "").trimWhitespace().isBlank
            let needsEmail = (signUpEmailTextField.text ?? "").trimWhitespace().isBlank
            let needsPassword = (signUpPasswordTextField.text ?? "").trimWhitespace().isBlank
            let authError: AuthError
            if needsFirstName {
                authError = .missingFirstName
            } else if needsLastName {
                authError = .missingLastName
            } else if needsEmail {
                authError = .missingEmail
            } else if needsPassword {
                authError = .missingPassword
            } else {
                authError = .unknown
            }
            let errorString = AuthError.errorString(for: authError)
            self.setSignUpError(errorString)
        }
    }
    
    private func setSignInError(_ errorString: String) {
        signInErrorLabel.text = errorString
        signInErrorLabel.isHidden = errorString.isEmpty
        view.setNeedsLayout()
        UIView.animate(withDuration: 0.3, delay: 0, options: .beginFromCurrentState, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func setSignUpError(_ errorString: String) {
        signUpErrorLabel.text = errorString
        signUpErrorLabel.isHidden = errorString.isEmpty
        view.setNeedsLayout()
        UIView.animate(withDuration: 0.3, delay: 0, options: .beginFromCurrentState, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
}

extension AuthViewController {
    
    // MARK: - Login State
    
    @objc private func signUpButtonPressed() {
        self.clearLabel(label: signInErrorLabel)
        self.setState(.signUp, animated: true)
    }
    
    @objc private func signInButtonPressed() {
        self.clearLabel(label: signUpErrorLabel)
        self.setState(.signIn, animated: true)
    }
    
    private func clearLabel(label: UILabel) {
        label.text = ""
        label.isHidden = true
    }
    
    private func setState(_ state: AuthViewControllerState, animated: Bool) {
        guard state != currentState else { return }
        let isTransitioningForward: Bool
        switch currentState {
        case .signIn:
            isTransitioningForward = false
        case .signUp:
            isTransitioningForward = true
        }
        
        let incomingStackView: UIStackView
        switch state {
        case .signIn:
            incomingStackView = signInStackView
        case .signUp:
            incomingStackView = signUpStackView
        }
        
        let existingStackView = self.currentStackView
        
        let stackViewSize = incomingStackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        var incomingViewFrame = CGRect.zero
        incomingViewFrame.origin.x = isTransitioningForward ? existingStackView?.bounds.maxX ?? (view.bounds.midX + stackViewSize.width) : (existingStackView?.bounds.minX ?? view.bounds.midX) - (stackViewSize.width)
        incomingViewFrame.origin.y = (existingStackView?.frame.midY ?? view.bounds.midY) - (stackViewSize.height/2.0)
        incomingViewFrame.size = stackViewSize
        
        incomingStackView.frame = incomingViewFrame
        incomingStackView.alpha = 0
        incomingStackView.layoutIfNeeded()
        view.addSubview(incomingStackView)
        
        let animationBlock = {
            var existingStackViewFrame = existingStackView?.frame ?? CGRect.zero
            existingStackViewFrame.origin.x = isTransitioningForward ? -existingStackViewFrame.size.width : self.view.bounds.maxX
            existingStackView?.frame = existingStackViewFrame
            existingStackView?.alpha = 0
            
            self.currentState = state
            self.currentStackView = incomingStackView
            self.viewDidLayoutSubviews()
        }
        
        let completionBlock: (Bool) -> () = { (_) in
            existingStackView?.removeFromSuperview()
        }
        if animated {
            UIView.animate(withDuration: 0.5, animations: animationBlock, completion: completionBlock)
        } else {
            animationBlock()
            completionBlock(true)
        }
        
    }
    
}

extension AuthViewController {
    
    // MARK: - Configure Stackview
    
    private func configure(_ stackView: UIStackView) {
        var constraints: [NSLayoutConstraint] = []
        for view in stackView.arrangedSubviews {
            if view is UIButton {
                let buttonWidthConstraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: stackView, attribute: .width, multiplier: self.buttonWidthScale, constant: 0)
                constraints.append(buttonWidthConstraint)
            } else if view is UITextField {
                let textFieldWidthConstraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: stackView, attribute: .width, multiplier: self.textFieldWidthScale, constant: 0)
                constraints.append(textFieldWidthConstraint)
            } else {
                let widthConstraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: stackView, attribute: .width, multiplier: 1, constant: 0)
                constraints.append(widthConstraint)
            }
        }
        stackView.addConstraints(constraints)
        
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        stackView.spacing = self.stackPadding
    }
    
}


