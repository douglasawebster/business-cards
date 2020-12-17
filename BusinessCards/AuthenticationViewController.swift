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
            return //incomingStackView = signInStackView
        case .signUp:
            return //incomingStackView = signUpStackView
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
    
    @objc private func signInButtonPressed() {
        self.setState(.signIn)
    }
    
    @objc private func signUpButtonPressed() {
        self.setState(.signUp)
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    private let buttonWidthScale: CGFloat = 0.6
    private let textFieldWidthScale: CGFloat = 0.9
    private let stackPadding: CGFloat = 12
    
    private lazy var signInButton: UIButton = {
        let signInButton = Theme.getButton(title: "Sign In")
        signInButton.setTitleColor(UIColor.clear, for: .disabled)
        signInButton.addTarget(self, action: #selector(signInButtonPressed), for: .touchUpInside)
        signInButton.layer.backgroundColor = Theme.keyColor.cgColor
        return signInButton
    }()
    
    private lazy var signUpButton: UIButton = {
        let signUpButton = Theme.getButton(title: "Sign Up")
        signUpButton.setTitleColor(UIColor.clear, for: .disabled)
        signUpButton.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        signUpButton.layer.backgroundColor = Theme.keyColor.cgColor
        return signUpButton
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        
        let signInButton = self.signInButton
        stackView.addArrangedSubview(signInButton)
        let signUpButton = self.signUpButton
        stackView.addArrangedSubview(signUpButton)
        
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
