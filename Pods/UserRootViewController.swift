//
//  UserRootViewController.swift
//  BusinessCards
//
//  Created by Douglas Webster on 12/17/20.
//

import Foundation
import UIKit
import Firebase

class UserRootViewController: UIViewController {
    init(user: User, hostViewController: UIViewController) {
        self.user = user
        self.hostViewController = hostViewController
        self.cardDetailViewController = CardDetailViewController(user: self.user)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public let user: User
    public let hostViewController: UIViewController
    private var cardDetailViewController: CardDetailViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.backgroundColor
        
        cardDetailViewController.willMove(toParent: self)
        view.addSubview(cardDetailViewController.view)
        self.addChild(cardDetailViewController)
        cardDetailViewController.didMove(toParent: self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cardDetailViewController.view.bounds = view.bounds
    }
    
    
    
}
