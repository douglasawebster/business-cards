//
//  AuthenticationViewController.swift
//  BusinessCards
//
//  Created by Douglas Webster on 12/11/20.
//

import Foundation
import UIKit

class AuthenticationViewController: UIViewController {
    
    public override func loadView() {
        self.view = myView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.backgroundColor
        myView.loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
    }
    
    // MARK: - TODO
    @objc private func loginButtonPressed() {
        return
    }
    
    private lazy var loginLabel: UILabel = {
        let label = Theme.getBoldLabel(text: "Login")
        return label
    }()
    
    private lazy var usernameField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Username")
        return textField
    }()
    
    private lazy var passwordField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Password")
        return textField
    }()
    
    private lazy var loginButton: UIButton = {
        let button = Theme.getButton(title: "Login")
        button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        let textColor: UIColor
        if #available(iOS 13, *) {
            textColor = UIColor.label
        } else {
            textColor = UIColor.darkText
        }
        button.setTitleColor(textColor, for: .normal)
        button.setTitle("Login", for: .normal)
        button.layer.backgroundColor = Theme.keyColor.cgColor
        return button
    }()
    
    private lazy var myView: View = {
       let view = View(loginLabel: loginLabel, usernameField: usernameField, passwordField: passwordField, loginButton: loginButton)
        return view
    }()
    
    private class View: UIView {
        init(loginLabel: UILabel, usernameField: UITextField, passwordField: UITextField, loginButton: UIButton) {
            self.loginLabel = loginLabel
            self.usernameField = usernameField
            self.passwordField = passwordField
            self.loginButton = loginButton
            
            super.init(frame: .zero)
            
            self.addSubview(loginLabel)
            self.addSubview(usernameField)
            self.addSubview(passwordField)
            self.addSubview(loginButton)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        let loginLabel: UILabel
        
        let usernameField: UITextField
        
        let passwordField: UITextField
        
        let loginButton: UIButton
        
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            return self.layout(in: CGRect(origin: bounds.origin, size: CGSize(width: 200, height: 200))).contentSize
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            let layout = self.layout(in: bounds.inset(by: safeAreaInsets))
            loginLabel.frame = layout.loginLabelFrame
            usernameField.frame = layout.usernameLabelFrame
            passwordField.frame = layout.passwordLabelFrame
            loginButton.frame = layout.loginButtonFrame
        }
        
        private func layout(in bounds: CGRect) -> Layout {
            let loginLabelSize = loginLabel.sizeThatFits(bounds.size)
            let loginLabelOrigin = CGPoint(x: bounds.midX - (loginLabelSize.width/2.0), y: bounds.origin.y)
            let loginLabelFrame = CGRect(origin: loginLabelOrigin, size: loginLabelSize)
            
            let usernameFieldSize = usernameField.sizeThatFits(bounds.size)
            let usernameFieldOrigin = CGPoint(x: bounds.midX - (usernameFieldSize.width/2.0), y: loginLabelFrame.maxY + padding)
            let usernameFieldFrame = CGRect(origin: usernameFieldOrigin, size: usernameFieldSize)
            
            let passwordFieldSize = passwordField.sizeThatFits(bounds.size)
            let passwordFieldOrigin = CGPoint(x: bounds.midX - (passwordFieldSize.width/2.0), y: usernameFieldFrame.maxY + padding)
            let passwordFieldFrame = CGRect(origin: passwordFieldOrigin, size: passwordFieldSize)
            
            let loginButtonSize = loginButton.sizeThatFits(bounds.size)
            let loginButtonOrigin = CGPoint(x: bounds.midX - (loginButtonSize.width/2.0), y: passwordFieldFrame.maxY + padding)
            let loginButtonFrame = CGRect(origin: loginButtonOrigin, size: loginButtonSize)
            
            let contentWidth: CGFloat = max(max(max(loginLabelFrame.width, usernameFieldFrame.width), passwordFieldFrame.width), loginButtonFrame.width)
            let contentHeight: CGFloat = loginLabelFrame.maxY - loginLabelFrame.minY
            
            return Layout(loginLabelFrame: loginLabelFrame, usernameLabelFrame: usernameFieldFrame, passwordLabelFrame: passwordFieldFrame, loginButtonFrame: loginButtonFrame, contentSize: CGSize(width: contentWidth, height: contentHeight))
            
        }
        
        private let padding: CGFloat = 8
        
        private struct Layout {
            let loginLabelFrame: CGRect
            let usernameLabelFrame: CGRect
            let passwordLabelFrame: CGRect
            let loginButtonFrame: CGRect
            let contentSize: CGSize
        }
    }
    
    
}
