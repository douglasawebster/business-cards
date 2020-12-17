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
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public let user: User
    public let hostViewController: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.green
    }
}
