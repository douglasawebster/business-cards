//
//  CardDetailViewController.swift
//  BusinessCards
//
//  Created by Douglas Webster on 12/17/20.
//

import Foundation
import UIKit
import Firebase

public struct Card {
    let firstName: String
    let middleName: String
    let lastName: String
    let companyName: String
    let position: String
    let phoneNumber: String
    let fax: String
    let email: String
    let address: String
    let websiteURL: String
}

class CardDetailViewController: UIViewController, UITabBarDelegate, UINavigationControllerDelegate {
    
    init(user: User) {
        self.user = user
        
        super.init(nibName: nil, bundle: nil)
        
        let ref = Database.database().reference()
        var dictionary: NSDictionary = [:]
        ref.child("cards").observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                dictionary = value
            }
            
            for key in dictionary.keyEnumerator() {
                let value: NSDictionary = dictionary[key] as! NSDictionary
                let firstName = value["firstName"] as? String ?? ""
                let middleName = value["middleName"] as? String ?? ""
                let lastName = value["lastName"] as? String ?? ""
                let companyName = value["companyName"] as? String ?? ""
                let position = value["position"] as? String ?? ""
                let phoneNumber = value["phoneNumber"] as? String ?? ""
                let fax = value["fax"] as? String ?? ""
                let email = value["email"] as? String ?? ""
                let address = value["address"] as? String ?? ""
                let websiteURL = value["websiteURL"] as? String ?? ""
                    
                let card = Card(firstName: firstName, middleName: middleName, lastName: lastName, companyName: companyName, position: position, phoneNumber: phoneNumber, fax: fax, email: email, address: address, websiteURL: websiteURL)
                self.cards.append(card)
            }
            
            self.wallet.cards = self.cards
                        
        }) { (error) in
            print("Error loading cards")
        }
        
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let user: User
    private var cards = [Card]()
    private var wallet: WalletViewController = WalletViewController()
    
    /*public override func loadView() {
        self.view = myView
     }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.backgroundColor
        currentViewController = walletViewController
        myView.frame = view.bounds
        view.addSubview(myView)
    }
    
    override func viewDidLayoutSubviews() {
        myView.frame = view.bounds
    }
    
    var currentViewController: UIViewController? = nil
    
    private lazy var tabBar: UITabBar = {
        let tabBar = UITabBar()
        tabBar.tintColor = Theme.keyColor
        tabBar.delegate = self
        return tabBar
    }()
    
    private lazy var walletViewController: UINavigationController = {
        let navigationController = UINavigationController(rootViewController: wallet)
        navigationController.delegate = self
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }()
    
    private lazy var myView: View = {
        let view = View(view: walletViewController.view, tabBar: tabBar)
        return view
    }()
    
    private class View: UIView {
        
        init(view: UIView, tabBar: UITabBar) {
            self.currentView = view
            self.tabBar = tabBar
            
            super.init(frame: .zero)
            
            self.addSubview(self.currentView)
            self.addSubview(self.tabBar)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        var currentView: UIView
        
        var tabBar: UITabBar
        
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            return self.layout(in: CGRect(origin: bounds.origin, size: CGSize(width: size.width, height: size.height))).contentSize
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            let layout = self.layout(in: bounds)
            self.currentView.frame = layout.currentViewFrame
            self.tabBar.frame = layout.tabBarFrame
        }
        
        private func layout(in bounds: CGRect) -> Layout {
            let tabBarSize = tabBar.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            var tabBarFrame = CGRect.zero
            tabBarFrame.origin.x = bounds.minX
            tabBarFrame.origin.y = bounds.maxY - tabBarSize.height
            tabBarFrame.size.width = tabBarSize.width
            tabBarFrame.size.height = tabBarSize.height
            
            let currentViewSize = CGSize(width: bounds.width, height: bounds.height - tabBarFrame.height)
            var currentViewFrame = CGRect.zero
            currentViewFrame.origin.x = bounds.minX
            currentViewFrame.origin.y = bounds.minY
            currentViewFrame.size.width = currentViewSize.width
            currentViewFrame.size.height = currentViewSize.height
            
            return Layout(currentViewFrame: currentViewFrame, tabBarFrame: tabBarFrame, contentSize: CGSize(width: currentViewFrame.width, height: tabBarFrame.maxY - currentViewFrame.minY))
        }
        
        struct Layout {
            let currentViewFrame: CGRect
            let tabBarFrame: CGRect
            let contentSize: CGSize
        }
        
    }
    
}
