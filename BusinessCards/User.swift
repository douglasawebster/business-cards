//
//  User.swift
//  BusinessCards
//
//  Created by Douglas Webster on 7/31/21.
//

import Foundation
import Firebase

class DatabaseReferenceItem {
    
    class var rootPath: String {
        return ""
    }
    
    class func databaseReference(for childKey: String) -> DatabaseReference {
        var databaseReferenace = FirebaseDatabase.Database.database().reference()
        if !rootPath.isEmpty {
            databaseReferenace = databaseReferenace.child(rootPath)
        }
        databaseReferenace = databaseReferenace.child(childKey)
        return databaseReferenace
    }
    
}

class User: DatabaseReferenceItem {
    
    private let user: Firebase.User
    public private(set) var firstName: String
    public private(set) var lastName: String
    
    override class var rootPath: String {
        "users"
    }
    
    init(fireUser: Firebase.User, rootDatabaseReference: DatabaseReference, firstName: String = "", lastName: String = "") {
        self.user = fireUser
        self.firstName = firstName
        self.lastName = lastName
        
    }
    
    class func publicDatabaseReference(for childkey: String) -> DatabaseReference {
        let userReference = User.databaseReference(for: childkey).child("public")
        return userReference
    }
    
    class func privateDatabaseReference(for childKey: String) -> DatabaseReference {
        let userReference = User.databaseReference(for: childKey).child("private")
        return userReference
    }
    
    
    
}
