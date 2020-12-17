//
//  AuthenticationViewController.swift
//  BusinessCards
//
//  Created by Douglas Webster on 12/11/20.
//

import Foundation
import UIKit
import Firebase

class AuthenticationViewController: UIViewController {
    
    public override func loadView() {
        self.view = myView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.backgroundColor
        currentStackView = buttonStackView
    }
    
    enum AuthViewControllerState {
        case buttons
        case signIn
        case signUp
        case forgotPassword
    }
    
    private var currentState: AuthViewControllerState = .buttons

    private var currentStackView: UIStackView?
    private func setState(_ updatedState: AuthViewControllerState) {
        guard currentState != updatedState else { return }
        
        let incomingStackView: UIStackView
        switch updatedState {
        case .buttons:
            incomingStackView = buttonStackView
        case .signIn:
            incomingStackView = signInStackView
        case .signUp:
            incomingStackView = signUpStackView
        case .forgotPassword:
            return //incomingStackView = forgotPasswordStackView
        }
        
        let existingStackView = self.currentStackView
        
        incomingStackView.frame = scrollView.frame
        incomingStackView.layoutIfNeeded()
        scrollView.addSubview(incomingStackView)
        
        self.currentState = updatedState
        self.currentStackView = incomingStackView
        self.myView.currentStackView = incomingStackView
        
        existingStackView?.removeFromSuperview()
        
        self.myView.setNeedsLayout()
    }
    
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
    
    @objc private func signInButtonPressed() {
        self.setState(.signIn)
    }
    
    @objc private func signUpButtonPressed() {
        self.setState(.signUp)
    }
    
    @objc private func attemptSignInButtonPressed() {
        if let email = signInEmailTextField.text, !email.isEmpty,
           let password = signInPasswordTextField.text, !password.isEmpty {
            Auth.auth().signIn(withEmail: email, password: password) { (signInResult, error) in
                if let error = error {
                    let errorString = self.errorString(for: error)
                    self.setSignInError(errorString)
                } else if let _ = signInResult {
                    self.setSignInError("")
                }
            }
        } else {
            let needsEmail = (signInEmailTextField.text ?? "").isEmpty
            let needsPassword = (signInPasswordTextField.text ?? "").isEmpty
            
            let errorString: String
            if needsEmail && needsPassword {
                errorString = NSLocalizedString("Needs email and password", comment: "")
            } else if needsEmail {
                errorString = NSLocalizedString("Needs email", comment: "")
            } else if needsPassword {
                errorString = NSLocalizedString("Needs password", comment: "")
            } else {
                errorString = NSLocalizedString("Unknown Error", comment: "")
            }
            self.setSignInError(errorString)
        }
    }
    
    private func setSignInError(_ errorString: String) {
        signInErrorLabel.text = errorString
        signInErrorLabel.isHidden = errorString.isEmpty
        myView.setNeedsLayout()
    }
    
    @objc private func attemptSignUpButtonPressed() {
        let firstNameText = signUpFirstNameTextField.text ?? ""
        let firstName = firstNameText.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastNameText = signUpLastNameTextField.text ?? ""
        let lastName = lastNameText.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailText = signUpEmailTextField.text ?? ""
        let email = emailText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !firstName.isEmpty,
           !lastName.isEmpty,
           !email.isEmpty,
           let password = signUpPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
           !password.isEmpty {
            Auth.auth().createUser(withEmail: email, password: password) { (signUpResult, error) in
                if let error = error {
                    let errorString = self.errorString(for: error)
                    self.setSignUpError(errorString)
                }
                else if let _ = signUpResult {
                    self.setSignUpError("")
                }
            }
        } else {
            let needsFirstName = (signUpFirstNameTextField.text ?? "").isEmpty
            let needsLastName = (signUpLastNameTextField.text ?? "").isEmpty
            let needsEmail = (signUpEmailTextField.text ?? "").isEmpty
            let needsPassword = (signUpPasswordTextField.text ?? "").isEmpty
            
            let errorString: String
            if needsFirstName && needsLastName && needsEmail && needsPassword {
                errorString = NSLocalizedString("Needs all", comment: "")
            } else if needsFirstName {
                errorString = NSLocalizedString("Needs first name", comment: "")
            } else if needsLastName {
                errorString = NSLocalizedString("Needs last name", comment: "")
            } else if needsEmail && needsPassword {
                errorString = NSLocalizedString("Needs email and password", comment: "")
            } else if needsEmail {
                errorString = NSLocalizedString("Needs email", comment: "")
            } else if needsPassword {
                errorString = NSLocalizedString("Needs password", comment: "")
            } else {
                errorString = NSLocalizedString("Needs all", comment: "")
            }
            self.setSignUpError(errorString)
        }
        
    }
    
    private func setSignUpError(_ errorString: String) {
        signUpErrorLabel.text = errorString
        signUpErrorLabel.isHidden = errorString.isEmpty
        myView.setNeedsLayout()
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    // MARK: - Button Stack View
    private let buttonWidthScale: CGFloat = 0.6
    private let textFieldWidthScale: CGFloat = 0.9
    private let stackPadding: CGFloat = 12
    
    private lazy var signInButton: UIButton = {
        let title = NSLocalizedString("Sign In", comment: "")
        let signInButton = self.getButton(title: title)
        signInButton.layer.backgroundColor = Theme.keyColor.cgColor
        signInButton.addTarget(self, action: #selector(signInButtonPressed), for: .touchUpInside)
        return signInButton
    }()
    
    private lazy var signUpButton: UIButton = {
        let title = NSLocalizedString("Sign Up", comment: "")
        let signUpButton = self.getButton(title: title)
        signUpButton.layer.backgroundColor = Theme.keyColor.cgColor
        signUpButton.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        return signUpButton
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.addArrangedSubview(self.signInButton)
        stackView.addArrangedSubview(self.signUpButton)
        
        var constraints: [NSLayoutConstraint] = []
        for view in stackView.arrangedSubviews {
            if view is UIButton {
                let buttonWidthConstraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: stackView, attribute: .width, multiplier: self.buttonWidthScale, constant: 0)
                constraints.append(buttonWidthConstraint)
            } else if view is UITextView {
                let textFieldWidthConstraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: stackView, attribute: .width, multiplier: self.textFieldWidthScale, constant: 0)
                constraints.append(textFieldWidthConstraint)
            }
            stackView.addConstraints(constraints)
            
            stackView.axis = .vertical
            stackView.alignment = .center
            stackView.spacing = self.stackPadding
        }
        
        return stackView
    }()
    
    // MARK: - Sign In Stack View
    private lazy var signInErrorLabel: UILabel = {
        return Theme.getErrorLabel()
    }()
    
    private lazy var signInEmailTextField: UITextField = {
        let placeholder = NSLocalizedString("Email", comment: "")
        let textField = self.getTextField(placeholder: placeholder, forPassword: false)
        return textField
    }()
    
    private lazy var signInPasswordTextField: UITextField = {
        let placeholder = NSLocalizedString("Password", comment: "")
        let textField = self.getTextField(placeholder: placeholder, forPassword: true)
        return textField
    }()
    
    private lazy var attemptSignInButton: UIButton = {
        let title = NSLocalizedString("Sign In", comment: "")
        let signInButton = self.getButton(title: title)
        signInButton.layer.backgroundColor = Theme.keyColor.cgColor
        signInButton.addTarget(self, action: #selector(attemptSignInButtonPressed), for: .touchUpInside)
        return signInButton
    }()
    
    private lazy var needToSignUpButton: UIButton = {
        let title = NSLocalizedString("Need to sign up?", comment: "")
        let signUpButton = self.getErrorButton(title: title)
        signUpButton.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        return signUpButton
    }()
    
    private lazy var signInStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.addArrangedSubview(self.signInErrorLabel)
        stackView.addArrangedSubview(self.signInEmailTextField)
        stackView.addArrangedSubview(self.signInPasswordTextField)
        stackView.addArrangedSubview(self.attemptSignInButton)
        stackView.addArrangedSubview(self.needToSignUpButton)
        
        self.configure(stackView)
        return stackView
    }()
    
    // MARK: - Sign Up Stack View
    private lazy var signUpErrorLabel: UILabel = {
        return Theme.getErrorLabel()
    }()
    
    private lazy var signUpFirstNameTextField: UITextField = {
        let placeholder = NSLocalizedString("First Name", comment: "")
        let textField = self.getTextField(placeholder: placeholder, forPassword: false)
        return textField
    }()
    
    private lazy var signUpLastNameTextField: UITextField = {
        let placeholder = NSLocalizedString("Last Name", comment: "")
        let textField = self.getTextField(placeholder: placeholder, forPassword: false)
        return textField
    }()
    
    private lazy var signUpEmailTextField: UITextField = {
        let placeholder = NSLocalizedString("Email", comment: "")
        let textField = self.getTextField(placeholder: placeholder, forPassword: false)
        return textField
    }()
    
    private lazy var signUpPasswordTextField: UITextField = {
        let placeholder = NSLocalizedString("Password", comment: "")
        let textField = self.getTextField(placeholder: placeholder, forPassword: true)
        return textField
    }()
    
    private lazy var needToSignInButton: UIButton = {
        let title = NSLocalizedString("Already have an account?", comment: "")
        let signInButton = self.getErrorButton(title: title)
        signInButton.addTarget(self, action: #selector(signInButtonPressed), for: .touchUpInside)
        return signInButton
    }()
    
    private lazy var attemptSignUpButton: UIButton = {
        let title = NSLocalizedString("Sign Up", comment: "")
        let signUpButton = self.getButton(title: title)
        signUpButton.layer.backgroundColor = Theme.keyColor.cgColor
        signUpButton.addTarget(self, action: #selector(attemptSignUpButtonPressed), for: .touchUpInside)
        return signUpButton

    }()
    
    private lazy var signUpStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.addArrangedSubview(self.signUpErrorLabel)
        stackView.addArrangedSubview(self.signUpFirstNameTextField)
        stackView.addArrangedSubview(self.signUpLastNameTextField)
        stackView.addArrangedSubview(self.signUpEmailTextField)
        stackView.addArrangedSubview(self.signUpPasswordTextField)
        stackView.addArrangedSubview(self.attemptSignUpButton)
        stackView.addArrangedSubview(self.needToSignInButton)
        
        self.configure(stackView)
        return stackView
    }()
    
    // MARK: - View
    private lazy var myView: View = {
        let view = View(scrollView: scrollView, stackView: buttonStackView)
        return view
    }()
    
    private class View: UIView {
        init(scrollView: UIScrollView, stackView: UIStackView) {
            self.scrollView = scrollView
            self.currentStackView = stackView
            
            super.init(frame: .zero)
            
            self.addSubview(scrollView)
            self.addSubview(currentStackView)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        let scrollView: UIScrollView
        
        var currentStackView: UIStackView
        
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            return self.layout(in: CGRect(origin: bounds.origin, size: CGSize(width: size.width, height: size.height))).contentSize
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            let layout = self.layout(in: bounds.inset(by: safeAreaInsets))
            currentStackView.frame = layout.stackViewFrame
            scrollView.contentSize = layout.contentSize
            scrollView.frame = layout.scrollViewFrame
            
            self.addSubview(currentStackView)
        }
        
        private func layout(in bounds: CGRect) -> Layout {
            let stackViewWidth: CGFloat = 400.0 //min(bounds.width * 0.8, 400)
            
            for view in currentStackView.arrangedSubviews {
                if let label = view as? UILabel {
                    label.preferredMaxLayoutWidth = stackViewWidth
                }
            }
            let stackViewSize = currentStackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            var stackViewFrame = CGRect.zero
            stackViewFrame.origin.x = bounds.midX - stackViewSize.width/2.0
            stackViewFrame.origin.y = bounds.midY - stackViewSize.height/2.0
            stackViewFrame.size.width = stackViewSize.width
            stackViewFrame.size.height = stackViewSize.height
            
            let contentSize = CGSize(width: stackViewFrame.width, height: stackViewFrame.height)
            
            
            return Layout(stackViewFrame: stackViewFrame, scrollViewFrame: stackViewFrame, contentSize: contentSize)
        }
        
        private let padding: CGFloat = 12
        
        private struct Layout {
            let stackViewFrame: CGRect
            let scrollViewFrame: CGRect
            let contentSize: CGSize
        }
    }
    
}

extension AuthenticationViewController {
    
    private func getButton(title: String) -> UIButton {
        let button = Theme.getButton(title: title)
        button.setTitleColor(UIColor.clear, for: .disabled)
        return button
    }
    
    private func getErrorButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        let color = UIColor.blue
        button.setTitleColor(color, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .footnote)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        return button
    }
    
    private func getTextField(placeholder: String, forPassword: Bool, withAutoCorrection: Bool = false) -> UITextField {
        let textField = Theme.getTextField(placeholder: placeholder)
        textField.autocorrectionType = withAutoCorrection ? .default : .no
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isSecureTextEntry = forPassword
        textField.setContentHuggingPriority(UILayoutPriority.required, for: .vertical)
        return textField
    }
    
}

extension AuthenticationViewController {
    
    public enum UserError: Error {
        case unknown
        case missingFirstName
        case missingLastName
        case network
        case invalidEmail
        case passwordTooShort
        case emailTaken
        case noAccount
        case invalidPassword
        case accountDisabled
    }
    
    private func errorString(for error: Error) -> String {
        let userError = error as? UserError ?? .unknown
        let errorString: String
        switch userError {
        case .network:
            errorString = NSLocalizedString("Network Error", comment: "")
        case .invalidEmail:
            errorString = NSLocalizedString("Email format error", comment: "")
        case .passwordTooShort:
            errorString = NSLocalizedString("Password too short", comment: "")
        case .emailTaken:
            errorString = NSLocalizedString("Email Taken", comment: "")
        case .noAccount:
            errorString = NSLocalizedString("No such account", comment: "")
        case .invalidPassword:
            errorString = NSLocalizedString("Invalid password", comment: "")
        case .accountDisabled:
            errorString = NSLocalizedString("Account disabled", comment: "")
        case .missingFirstName:
            errorString = NSLocalizedString("Needs first name", comment: "")
        case .missingLastName:
            errorString = NSLocalizedString("Needs last name", comment: "")
        case .unknown:
            errorString = NSLocalizedString("Unknown Error", comment: "")
        }
        return errorString
    }
    
}
