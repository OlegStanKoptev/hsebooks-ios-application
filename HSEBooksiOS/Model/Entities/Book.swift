//
//  Book.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 04.05.2021.
//

import Foundation

struct Book: RemoteEntity {
    var id: Int
    var creationDate: String
    var publicityStatus: PublicityStatus
    var creatorId: Int?
    var baseId: Int
    var ownerId: Int
    var townId: Int
    var exteriorQualityId: Int
    var photoId: Int?
    
    enum PublicityStatus: String, Equatable, Codable {
        case `private` = "Private"
        case `public` = "Public"
    }
    
    static func getItems(amount: Int) -> [Book] {
        var array = [Book]()
        for i in 1...amount {
            array.append(
                Book(id: i, creationDate: "2021-04-23T11:55:59.622+00:00", publicityStatus: .public, creatorId: 10, baseId: 11, ownerId: 10, townId: 50, exteriorQualityId: 3, photoId: 52)
            )
        }
        return array
    }
    
    static let book = RemoteDataCredentials(name: "Book", endpoint: "book")
}
