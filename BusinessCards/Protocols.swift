//
//  Protocols.swift
//  BusinessCards
//
//  Created by Douglas Webster on 7/30/21.
//

import Foundation
import UIKit
import Firebase

protocol UserAuthDelegate {
    func updateUser(_ viewController: UIViewController, user: Firebase.User, animated: Bool)
}
