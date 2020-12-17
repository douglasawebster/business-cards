//
//  RootViewController.swift
//  BusinessCards
//
//  Created by Douglas Webster on 12/17/20.
//

import Foundation
import UIKit
import FirebaseAuth

class RootViewController: UIViewController {
    
    enum LoginResult {
        case success(User)
        case failure
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.backgroundColor
        
        let fireUser = Auth.auth().currentUser
        let loginResult: LoginResult
        if let user = fireUser {
            loginResult = .success(user)
        } else {
            loginResult = .failure
        }
        self.updateCurrentViewController(loginResult: loginResult)
     }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        currentViewController?.view.frame = view.bounds
    }
    
    func update(user: User?, caller: UIViewController) {
        caller.dismiss(animated: false, completion: nil)
        if let currentViewController = self.currentViewController {
            currentViewController.willMove(toParent: nil)
            currentViewController.view.removeFromSuperview()
            currentViewController.removeFromParent()
            currentViewController.didMove(toParent: nil)
        }
        let loginResult: LoginResult
        if let user = user {
            loginResult = .success(user)
        } else {
            loginResult = .failure
        }
        self.updateCurrentViewController(loginResult: loginResult)
    }
    
    private var currentViewController: UIViewController?
    private func updateCurrentViewController(loginResult: LoginResult) {
        let viewController: UIViewController
        switch loginResult {
        case .success(let user):
            if let currentUserViewController = self.currentViewController as? UserRootViewController,
                currentUserViewController.user == user {
                viewController = currentUserViewController
            } else {
                viewController = UserRootViewController(user: user, hostViewController: self)
            }
        case .failure:
            viewController = AuthenticationViewController(rootViewController: self)
        }
        
        let viewControllerToRemove = self.currentViewController
        guard viewControllerToRemove != viewController else { return }
        
        var viewControllersToDismiss = [UIViewController]()
        var currentPresentedViewController = viewControllerToRemove?.presentedViewController
        while (currentPresentedViewController != nil) {
            guard let presentedViewController = currentPresentedViewController else { break }
            viewControllersToDismiss.append(presentedViewController)
            currentPresentedViewController = presentedViewController.presentedViewController
        }
        for viewController in viewControllersToDismiss.reversed() {
            viewController.dismiss(animated: false, completion: nil)
        }
        self.currentViewController = viewController
        viewController.willMove(toParent: self)
        view.addSubview(viewController.view)
        self.addChild(viewController)
        viewController.didMove(toParent: self)

        viewControllerToRemove?.willMove(toParent: nil)
        viewControllerToRemove?.removeFromParent()
        viewControllerToRemove?.view.removeFromSuperview()
        viewControllerToRemove?.didMove(toParent: nil)
    }
    
}
