//
//  StringExtension.swift
//  SimpleWeather
//
//  Created by James Yoo on 2018-02-13.
//  Copyright © 2018 James Yoo. All rights reserved.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
