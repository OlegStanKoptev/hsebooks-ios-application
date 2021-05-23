//
//  BookBase.swift
//  HSEBooksiOSApp
//
//  Created by Oleg Koptev on 23.04.2021.
//

import Foundation

struct BookBase: RemoteEntity {
    var id: Int
    var creationDate: String
    var author: String
    var language: Language
    var title: String
    var numberOfPages: Int
    var publishYear: Int
    var description: String?
    var genreIds: [Int]
    var rating: Double
    var bookIds: [Int]
    var wishersIds: [Int]
    var photoId: Int?
    
    static func getItems(amount: Int) -> [BookBase] {
        var array = [BookBase]()
        for i in 1...amount {
            array.append(
                BookBase(id: i, creationDate: "2021-04-23T11:55:59.622+00:00", author: "Author \(i)", language: .RU, title: "Title \(i)", numberOfPages: 200+i, publishYear: 2000+i, description: "Some random description", genreIds: [1, 2, 3], rating: Double(i) * 5.0 / Double(amount), bookIds: [1, 2, 3], wishersIds: [], photoId: nil)
            )
        }
        return array
    }
    
    var availability: String {
        bookIds.isEmpty ? "None available" : "\(bookIds.count) available"
    }
    
    static let book = RemoteDataCredentials(name: "BookBase", endpoint: "bookBase")
    
    static let home = (
        name: "Home",
        sections: [
            recommended,
            new,
            rate
        ]
    )
    
    static let recommended = RemoteDataCredentials(
        name: "Recommended",
        endpoint: "bookBase",
        params: [
            "sortBy": "recommended"
        ]
    )
    
    static let new = RemoteDataCredentials(
        name: "New",
        endpoint: "bookBase",
        params: [
            "sortBy": "date"
        ]
    )
    
    static let rate = RemoteDataCredentials(
        name: "Most Rated",
        endpoint: "bookBase",
        params: [
            "sortBy": "rate"
        ]
    )
    
    static let search = RemoteDataCredentials(endpoint: "bookBase/search")
    static let request = RemoteDataCredentials(endpoint: "bookBase/request")
    static let rating = RemoteDataCredentials(endpoint: "bookBase/rate")
}
