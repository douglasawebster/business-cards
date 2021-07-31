//
//  UserRootViewController.swift
//  BusinessCards
//
//  Created by Douglas Webster on 7/29/21.
//

import Firebase
import Foundation
import UIKit

enum CardDetailType: Int {
    case wallet
    case search
    case cards
}

class UserRootViewController: UIViewController, UINavigationControllerDelegate {
    
    let user: User
    
    var currentViewController: UIViewController? = nil

    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = Theme.backgroundColor
        
        var tabBarItems: [UITabBarItem] = []
        
        if let walletTabBarItem = self.walletViewController.tabBarItem {
            walletTabBarItem.tag = CardDetailType.wallet.rawValue
            tabBarItems.append(walletTabBarItem)
        }
        
        tabBar.items = tabBarItems
        tabBar.selectedItem = walletViewController.tabBarItem
        view.addSubview(tabBar)
        self.setCurrentViewController(walletViewController)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var availableBound = view.bounds
        
        let tabBarSize = tabBar.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        var tabBarFrame = CGRect.zero
        tabBarFrame.origin.x = availableBound.minX
        tabBarFrame.origin.y = availableBound.maxY - tabBarSize.height
        tabBarFrame.size.width = availableBound.width
        tabBarFrame.size.height = availableBound.height
        
        tabBar.frame = tabBarFrame
        tabBar.layoutIfNeeded()
        
        availableBound.size.height -= tabBarSize.height
        
        currentViewController?.view.frame = availableBound
    }
    
    private lazy var walletViewController: UINavigationController = {
        let walletViewController = WalletViewController()
        let navigationController = UINavigationController(rootViewController: walletViewController)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.delegate = self
        return navigationController
    }()
    
    private lazy var tabBar: UITabBar = {
        let tabBar = UITabBar()
        tabBar.delegate = self
        return tabBar
    }()
}

extension UserRootViewController: UITabBarDelegate {
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let cardDetailType = CardDetailType(rawValue: item.tag) else { return }
        switch cardDetailType {
        case .wallet:
            self.setCurrentViewController(walletViewController)
        case .search:
            self.setCurrentViewController(walletViewController)
        case .cards:
            self.setCurrentViewController(walletViewController)
        }
    }
    
}

extension UserRootViewController {
    
    private func setCurrentViewController(_ viewController: UIViewController) {
        guard viewController != currentViewController else { return }
        if let outgoingViewController = self.currentViewController {
            outgoingViewController.willMove(toParent: nil)
            outgoingViewController.view.removeFromSuperview()
            outgoingViewController.removeFromParent()
            outgoingViewController.didMove(toParent: nil)
            self.currentViewController = nil
        }
        
        self.currentViewController = viewController
        
        viewController.willMove(toParent: self)
        self.addChild(viewController)
        view.addSubview(viewController.view)
        viewController.view.frame = view.bounds
        viewController.didMove(toParent: self)
        tabBar.invalidateIntrinsicContentSize()
        tabBar.setNeedsLayout()
        view.bringSubviewToFront(tabBar)
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
}
