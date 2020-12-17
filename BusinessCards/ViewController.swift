//
//  ViewController.swift
//  BusinessCards
//
//  Created by Douglas Webster on 12/16/20.
//

import Foundation
import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.backgroundColor
        
        let authViewController = AuthenticationViewController()
        self.currentViewController = authViewController
        self.willMove(toParent: self)
        view.addSubview(authViewController.view)
        self.addChild(authViewController)
        authViewController.didMove(toParent: self)
     }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        currentViewController?.view.frame = view.bounds
    }
    
    private var currentViewController: UIViewController?
    
}
