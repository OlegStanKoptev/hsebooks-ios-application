//
//  BookBaseRequest.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 20.05.2021.
//

import Foundation

struct BookBaseRequest: RemoteEntity {
    var id: Int
    var creationDate: String
    var author: String
    var language: Language
    var title: String
    var numberOfPages: Int
    var publishYear: Int
    var description: String?
    var genreIds: [Int]
    var status: RequestStatus
    var creatorId: Int
    var bookIds: [Int]
    var wishersIds: [Int]
    var photoId: Int?
    
    static func getItems(amount: Int) -> [BookBaseRequest] {
        var result = [Self]()
        for i in 1..<5 {
            result.append(.init(id: i, creationDate: "", author: "Author \(i)", language: .RU, title: "Title \(i)", numberOfPages: 200+i, publishYear: 2000+i, description: nil, genreIds: [], status: .Accepted, creatorId: User.default.id, bookIds: [], wishersIds: [], photoId: nil))
        }
        return result
    }
    
    struct PostRequest: Encodable {
        var author: String
        var language: Language
        var title: String
        var numberOfPages: Int
        var genreIds: [Int]
        var publishYear: Int
    }
}
