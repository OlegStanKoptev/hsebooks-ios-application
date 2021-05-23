//
//  Double+Extension.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 15.05.2021.
//

import Foundation

extension Double {
    var asStringWithTwoDigits: String {
        String(format: "%.2f", self)
    }
    
    var asStringWithOneDigit: String {
        String(format: "%.1f", self)
    }
}
