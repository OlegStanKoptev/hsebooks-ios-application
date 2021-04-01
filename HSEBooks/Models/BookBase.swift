//
//  BookBase.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 28.03.2021.
//

import Foundation
import Combine

struct BookBase: Identifiable, Equatable, Codable {
    var id: Int
    var creationDate: String
    var author: String
    var language: String
    var title: String
    var numberOfPages: Int
    var publishYear: Int
    var description: String?
    var genreIds: [Int]
    var rating: Double
    var bookIds: [Int]
    var wishersIds: [Int]
    var photoId: Int?
    
    static var previewInstance: BookBase {
        return BookBase(id: 1, creationDate: "01.01.01", author: "Author", language: "ENG", title: "Title", numberOfPages: 1, publishYear: 1, description: "Description", genreIds: [], rating: 5.0, bookIds: [], wishersIds: [], photoId: nil)
    }
}
