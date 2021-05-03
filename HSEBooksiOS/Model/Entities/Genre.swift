//
//  Genre.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 01.05.2021.
//

import Foundation

struct Genre: Identifiable, Decodable {
    var id: Int
    var creationDate: String
    var name: String
    var bookBaseIds: [Int]
    
    static func getGenres(amount: Int) -> [Genre] {
        var array = [Genre]()
        for i in 0..<amount {
            array.append(
                Genre(id: i, creationDate: "", name: "Genre \(i)", bookBaseIds: Array(0...i))
            )
        }
        return array
    }
    
    static func genreCredentials(for id: Int, title: String) -> RemoteDataCredentials {
        return RemoteDataCredentials(name: title, endpoint: "bookBase/byGenres", params: ["genres": "\(id)"])
    }
    
    static let all = RemoteDataCredentials(
        name: "All Genres",
        endpoint: "genre"
    )
}
