//
//  ExteriorQuality.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 16.05.2021.
//

import Foundation

struct ExteriorQuality: RemoteEntity {
    var id: Int
    var creationDate: String
    var name: String
    
    static func getItems(amount: Int) -> [ExteriorQuality] {
        var result: [ExteriorQuality] = []
        for i in 1...amount {
            result.append(.init(id: i, creationDate: "", name: "Quality \(i)"))
        }
        return result
    }
    
    static let all = RemoteDataCredentials(endpoint: "exteriorQuality")
}
