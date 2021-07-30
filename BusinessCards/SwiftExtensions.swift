//
//  SwiftExtensions.swift
//  BusinessCards
//
//  Created by Douglas Webster on 7/30/21.
//

import Foundation

extension String {
    var isBlank: Bool {
        guard !self.isEmpty else { return true }
        let validCharacterSet = CharacterSet.whitespacesAndNewlines.inverted
        let validCharacterRange = self.rangeOfCharacter(from: validCharacterSet)
        return validCharacterRange == nil
    }
    
    func trimWhitespace() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
