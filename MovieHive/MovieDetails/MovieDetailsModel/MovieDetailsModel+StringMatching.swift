//
//  MovieDetailsModel+StringMatching.swift
//  CineHub
//
//  Created by Raul Mena on 5/14/24.
//

import Foundation

extension MovieDetailsModel {
    func removeNonAlphabeticCharacters(from input: String) -> String? {
        // Regular expression pattern to match non-alphabetic characters
        let pattern = "[^a-zA-Z0-9]+"
        
        // Create a regular expression with the pattern
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            print("Invalid regular expression pattern")
            return nil
        }
        
        // Define the range of the input string
        let range = NSRange(location: 0, length: input.utf16.count)
        // Replace matches of the regular expression with an empty string
        let modifiedString = regex.stringByReplacingMatches(in: input, options: [], range: range, withTemplate: "_")
        return modifiedString
    }
    
    
    func extractPercentage(from text: String) -> String? {
        let pattern = #"\"scorePercent\":\"(\d+%)\",\"title\":\"Tomatometer\""#
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        
        guard let regex = regex else {
            print("Invalid regular expression")
            return nil
        }
        
        let range = NSRange(text.startIndex..<text.endIndex, in: text)
        if let match = regex.firstMatch(in: text, options: [], range: range) {
            if let percentageRange = Range(match.range(at: 1), in: text) {
                return String(text[percentageRange])
            }
        }
        
        return nil
    }
}
