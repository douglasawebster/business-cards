//
//  UserRootViewController.swift
//  BusinessCards
//
//  Created by Douglas Webster on 7/29/21.
//

import Firebase
import Foundation
import UIKit

class UserRootViewController: UIViewController {
    
    let user: Firebase.User
    
    init(user: Firebase.User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = .systemPink
    }
}
