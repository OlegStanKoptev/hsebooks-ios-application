//
//  BookPhoto.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 15.05.2021.
//

import Foundation

struct BookPhoto: RemoteEntity {
    var id: Int
    var creationDate: String
    var image: String
    var bookId: Int
    var creatorId: Int
    
    static func getItems(amount: Int) -> [BookPhoto] {
        var array = [BookPhoto]()
        for i in 1...amount {
            array.append(
                BookPhoto(id: i, creationDate: "", image: "", bookId: 1, creatorId: 1)
            )
        }
        return array
    }
    
    static let all = RemoteDataCredentials(endpoint: "bookPhoto")
}
