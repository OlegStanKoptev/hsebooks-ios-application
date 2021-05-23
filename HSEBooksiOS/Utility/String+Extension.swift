//
//  String+Extension.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 20.05.2021.
//

import Foundation

extension String {
    var asDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSSZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        if let date = formatter.date(from: self) {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            return formatter.string(from: date)
        } else {
            return "Wrong Date Format"
        }
    }
}
