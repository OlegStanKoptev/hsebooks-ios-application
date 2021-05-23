//
//  Language.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 20.05.2021.
//

import Foundation

enum Language: String, CaseIterable, RemoteEntity {
    var id: Self { self }
    
    case RU, ENG
    
    static func getItems(amount: Int) -> [Language] {
        return self.allCases
    }
}
