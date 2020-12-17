//
//  User.swift
//  BusinessCards
//
//  Created by Douglas Webster on 12/17/20.
//

import Foundation

public class UserMetadata {
    
    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
    
    private let firstName: String
    private let lastName: String
}

extension UserMetadata {
    
    public func publicMetadata() -> [String:Any] {
        /*let publicMetadata: [String:Any] = [
            "name" : [
                "firstName": firstName,
                "lastName": lastName
            ],
            "cards": [
                [:]
            ]
        ]*/
        
        let publicMetadata: [String:Any] = [
            "name" : [
                "firstName": firstName,
                "lastName": lastName
            ]
        ]
        return publicMetadata
    }
    
    public func privateMetadata() -> [String:Any] {
        let privateMetadata: [String:Any] = [
            "wallet": false
        ]
        return privateMetadata
    }
    
}
