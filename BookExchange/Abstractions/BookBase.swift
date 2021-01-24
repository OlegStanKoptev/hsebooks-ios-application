//
//  BookBase.swift
//  BookExchange
//
//  Created by Oleg Koptev on 22.01.2021.
//

import Foundation

struct BookBase: Decodable {
    var id: Int
    var author: String
    var language: String
    var title: String
    var numberOfPages: Int
    var publishYear: Int
    var pictureUrl: URL
    var wishers: [Int]
    var genres: [Int]
    var rating: Float
}
