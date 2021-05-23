//
//  Town.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 07.05.2021.
//

import Foundation

struct Town: RemoteEntity {
    var id: Int
    var creationDate: String
    var name: String
    var bookIds: [Int]
    
    static func getItems(amount: Int) -> [Town] {
        var result: [Town] = []
        for i in 1...amount {
            result.append(.init(id: i, creationDate: "2021-05-06T20:15:55.724+00:00", name: "Town \(i)", bookIds: []))
        }
        return result
    }
    
    static let all = RemoteDataCredentials(name: "Town", endpoint: "town")
}
