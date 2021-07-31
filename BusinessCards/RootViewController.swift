//
//  RootViewController.swift
//  BusinessCards
//
//  Created by Douglas Webster on 7/29/21.
//

import Foundation
import UIKit
import Firebase

class RootViewController: UIViewController {
    
    private var currentViewController: UIViewController?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.attemptAutoSignIn()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Theme.backgroundColor
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.currentViewController?.view.frame = self.view.bounds
    }
    
    private func attemptAutoSignIn() {
        AuthProvider.autoSignIn(completionHandler: { [weak self] (result) in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                var user: User?
                switch result {
                case .success(let authedUser):
                    user = authedUser
                case .failure(_):
                    user = nil
                }
                strongSelf.updateCurrentViewController(user: user, animated: false)
            }
        })
    }
    
}

extension RootViewController {
    
    public func updateCurrentViewController(user: User?, animated: Bool) {
        let viewController: UIViewController
        if let existingUser = user {
            viewController = UserRootViewController(user: existingUser)
        } else {
            viewController = AuthViewController()
            (viewController as! AuthViewController).delegate = self
        }
        
        let viewControllerToRemove = self.currentViewController
        guard viewControllerToRemove != viewController else { return }
        
        var viewControllersToDismiss = [UIViewController]()
        var currentPresentedViewController = viewControllerToRemove?.presentedViewController
        while let presentedViewController = currentPresentedViewController {
            viewControllersToDismiss.append(presentedViewController)
            currentPresentedViewController = presentedViewController.presentedViewController
        }
        for viewController in viewControllersToDismiss.reversed() {
            viewController.dismiss(animated: false, completion: nil)
        }
        
        viewController.willMove(toParent: self)
        view.addSubview(viewController.view)
        self.addChild(viewController)
        viewController.didMove(toParent: self)
        
        if animated {
            viewController.view.alpha = 0.0
            UIView.animate(withDuration: 0.3, animations: {
                viewController.view.alpha = 1.0
                viewControllerToRemove?.view.alpha = 0.0
            }) { (_) in
                viewControllerToRemove?.willMove(toParent: self)
                viewControllerToRemove?.removeFromParent()
                viewControllerToRemove?.view.removeFromSuperview()
                viewControllerToRemove?.didMove(toParent: self)
            }
        } else {
            viewControllerToRemove?.willMove(toParent: nil)
            viewControllerToRemove?.removeFromParent()
            viewControllerToRemove?.view.removeFromSuperview()
            viewControllerToRemove?.didMove(toParent: nil)
        }
        
        self.currentViewController = viewController
    }
    
}

extension RootViewController: UserAuthDelegate {    
    
    func updateUser(_ viewController: UIViewController, user: User, animated: Bool) {
        viewController.dismiss(animated: true, completion: nil)
        if let currentViewController = self.currentViewController {
            currentViewController.willMove(toParent: nil)
            currentViewController.view.removeFromSuperview()
            currentViewController.removeFromParent()
            currentViewController.didMove(toParent: nil)
        }
        self.updateCurrentViewController(user: user, animated: true)
    }
    
}
