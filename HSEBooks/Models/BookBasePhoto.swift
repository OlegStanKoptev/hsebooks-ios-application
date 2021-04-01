//
//  BookBasePhoto.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 28.03.2021.
//

import Foundation

struct BookBasePhoto: Codable {
    var id: Int
    var creationDate: String
    var image: String
    var bookBaseId: Int
    var creatorId: Int
}
