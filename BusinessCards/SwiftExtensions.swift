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
    
    func editDistance(to: String) -> Int {
        let from = self
        let fromLength = from.count
        let toLength = to.count
        var dp: [[Int]] = Array(repeating: Array(repeating: 0, count: fromLength+1), count: toLength+1)
        for i in 0...toLength {
            for j in 0...fromLength {
                if i == 0 {
                    dp[i][j] = j
                } else if j == 0 {
                    dp[i][j] = i
                } else if from[j-1] == to[i-1] {
                    dp[i][j] = dp[i-1][j-1]
                } else {
                    dp[i][j] = 1 + min(min(dp[i][j-1] , dp[i-1][j]), dp[i-1][j-1])
                }
            }
        }
        return dp[toLength][fromLength]
    }
    
    func longestCommonSubsequence(to: String) -> Int {
        let from = self
        let fromLength = from.count
        let toLength = to.count
        var dp: [[Int]] = Array(repeating: Array(repeating: 0, count: fromLength+1), count: toLength+1)
        for i in 0...toLength {
            for j in 0...fromLength {
                if i == 0 || j == 0 {
                    dp[i][j] = 0
                } else if from[j-1] == to[i-1] {
                    dp[i][j] = 1 + dp[i-1][j-1]
                } else {
                    dp[i][j] = max(dp[i][j-1], dp[i-1][j])
                }
            }
        }
        return dp[toLength][fromLength]
    }
    
    func longestCommonSubstring(to: String) -> Int {
        let from = self
        let fromLength = from.count
        let toLength = to.count
        var longest = 0
        var dp: [[Int]] = Array(repeating: Array(repeating: 0, count: fromLength+1), count: toLength+1)
        for i in 0...toLength {
            for j in 0...fromLength {
                if i == 0 || j == 0 {
                    dp[i][j] = 0
                } else if from[j-1] == to[i-1] {
                    dp[i][j] = 1 + dp[i-1][j-1]
                    longest = max(longest, dp[i][j])
                } else {
                    dp[i][j] = 0
                }
            }
        }
        return longest
    }
    
    func commonPrefixLength(to: String) -> Int {
        let from = self
        let fromLength = from.count
        let toLength = to.count
        var prefixLength = 0
        for index in 0..<fromLength {
            if index < toLength && to[index] == from[index] {
                prefixLength += 1
            }
        }
        return prefixLength
    }
    
    subscript (characterIndex: Int) -> Character {
            return self[index(startIndex, offsetBy: characterIndex)]
    }
}

