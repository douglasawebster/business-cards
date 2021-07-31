//
//  DatabaseKeys.swift
//  BusinessCards
//
//  Created by Douglas Webster on 7/31/21.
//

import Foundation

extension User {
    
    public enum Key: String, CodingKey, CaseIterable {
        case wallet
        case nameDictionaryKey = "name"
        case firstName
        case lastName
        case cards
    }
    
}
