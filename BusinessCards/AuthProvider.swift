//
//  AuthProvider.swift
//  Pods
//
//  Created by Douglas Webster on 7/29/21.
//

import Foundation
import FirebaseAuth
import Firebase

public enum AuthError: Error {
    case unknown
    case missingFirstName
    case missingLastName
    case missingEmail
    case missingPassword
    case invalidEmail
    case emailTaken
    case passwordTooShort
    case invalidPassword
    case noAccount
    case accountDisabled
    case expiredToken
    case network
    
    public static func errorString(for error: AuthError) -> String {
        let errorString: String
        switch error {
        case .missingFirstName:
            errorString = NSLocalizedString("Needs first name", comment: "")
        case .missingLastName:
            errorString = NSLocalizedString("Needs last name", comment: "")
        case .missingEmail:
            errorString = NSLocalizedString("Needs email", comment: "")
        case .missingPassword:
            errorString = NSLocalizedString("Needs password", comment: "")
        case .invalidEmail:
            errorString = NSLocalizedString("Email format error", comment: "")
        case .emailTaken:
            errorString = NSLocalizedString("Email taken", comment: "")
        case .passwordTooShort:
            errorString = NSLocalizedString("Password too short", comment: "")
        case .invalidPassword:
            errorString = NSLocalizedString("Invalid password", comment: "")
        case .noAccount:
            errorString = NSLocalizedString("No such account", comment: "")
        case .accountDisabled:
            errorString = NSLocalizedString("Account disasbled", comment: "")
        case .expiredToken:
            errorString = NSLocalizedString("Auto sign in failed", comment: "")
        case .network:
            errorString = NSLocalizedString("Network error", comment: "")
        case .unknown:
            errorString = NSLocalizedString("Unknown error", comment: "")
        }
        return errorString
    }
}

class AuthProvider {
    
    public static func autoSignIn(completionHandler: @escaping (Result<User, AuthError>) -> ()) {
        let fireUser = Auth.auth().currentUser
        if let authedUser = fireUser {
            let databaseReference = User.databaseReference(for: authedUser.uid)
            let user = User(fireUser: authedUser, rootDatabaseReference: databaseReference)
            completionHandler(.success(user))
        } else {
            completionHandler(.failure(.expiredToken))
        }
    }
    
    public static func signIn(email: String, password: String, completionHandler: @escaping (Result<User, AuthError>) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (signInResult, fireError) in
            if let authedUser = signInResult?.user, fireError == nil {
                let databaseReference = User.databaseReference(for: authedUser.uid)
                let user = User(fireUser: authedUser, rootDatabaseReference: databaseReference)
                completionHandler(.success(user))
            } else {
                let authError = self.authError(for: fireError)
                completionHandler(.failure(authError))
            }
        }
    }
    
    public static func signUp(firstName: String, lastName: String, email: String, password: String, completionHandler: @escaping (Result<User, AuthError>) -> ()) {
        let trimmedFirstName = firstName.trimWhitespace()
        guard !trimmedFirstName.isBlank else {
            completionHandler(.failure(.missingFirstName))
            return
        }
        let trimmedLastName = lastName.trimWhitespace()
        guard !trimmedLastName.isBlank else {
            completionHandler(.failure(.missingLastName))
            return
        }
        Auth.auth().createUser(withEmail: email, password: password, completion: { (signInResult, fireError) in
            if let authedUser = signInResult?.user, fireError == nil {
                let changeRequest = authedUser.createProfileChangeRequest()
                changeRequest.displayName = trimmedFirstName + " " + trimmedLastName
                changeRequest.commitChanges(completion: { (changeError) in
                    if let error = changeError {
                        let updateError = self.authError(for: error)
                        completionHandler(.failure(updateError))
                    } else {
                        let databaseReference = User.publicDatabaseReference(for: authedUser.uid)
                        let namesDictionary = [
                            User.Key.firstName.rawValue : trimmedFirstName,
                            User.Key.lastName.rawValue : trimmedLastName
                        ]
                        let userValues = [User.Key.nameDictionaryKey.rawValue : namesDictionary]
                        databaseReference.setValue(userValues)
                        let user = User(fireUser: authedUser, rootDatabaseReference: databaseReference)
                        completionHandler(.success(user))
                    }
                })
            } else {
                let authError = self.authError(for: fireError)
                completionHandler(.failure(authError))
            }
        })
    }
    
    private static func authError(for error: Error?) -> AuthError {
        guard let existingError = error else { return .unknown }
        let authError: AuthError
        let domain = existingError._domain
        let code = existingError._code
        if domain == AuthErrorDomain, let fireCode = AuthErrorCode(rawValue: code) {
            switch fireCode {
            case .networkError:
                authError = .network
            case .userNotFound:
                authError = .noAccount
            case .invalidEmail:
                authError = .invalidEmail
            case .wrongPassword:
                authError = .invalidPassword
            case .weakPassword:
                authError = .passwordTooShort
            case .emailAlreadyInUse:
                authError = .emailTaken
            case .invalidUserToken:
                authError = .expiredToken
            default:
                authError = .unknown
            }
        } else {
            authError = .unknown
        }
        return authError
    }
    
}


