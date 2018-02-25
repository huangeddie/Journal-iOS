//
//  UISearchBar.swift
//  Journal
//
//  Created by Edward Huang on 1/15/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import Foundation
import UIKit

extension UISearchBar {
    func getLowerCaseWords() -> [String] {
        guard let subsequences = text?.split(separator: " ") else {
            fatalError("Couldn't get search bar text")
        }
        
        let words = subsequences.map { (substring) -> String in
            return String(substring).lowercased()
        }
        
        return words
    }
}
