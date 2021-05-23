//
//  BookBasePhoto.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 28.03.2021.
//

import Foundation

struct BookBasePhoto: RemoteEntity {
    var id: Int
    var creationDate: String
    var image: String
    var bookBaseId: Int
    var creatorId: Int
    
    static func getItems(amount: Int) -> [BookBasePhoto] {
        var array = [BookBasePhoto]()
        for i in 1...amount {
            array.append(
                BookBasePhoto(id: i, creationDate: "", image: "", bookBaseId: 1, creatorId: 1)
            )
        }
        return array
    }
    
    static let all = RemoteDataCredentials(endpoint: "bookBasePhoto")
}
