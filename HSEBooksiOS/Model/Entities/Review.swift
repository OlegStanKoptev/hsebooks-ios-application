//
//  Review.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 23.05.2021.
//

import Foundation

struct Review: RemoteEntity {
    var id: Int
    var creationDate: String
    var rate: Double
    var body: String
    var creatorId: Int
    var ratedBookBaseId: Int
    
    static func getItems(amount: Int) -> [Review] {
        var result = [Review]()
        for i in 1...amount {
            result.append(.init(id: i, creationDate: "", rate: 5, body: "", creatorId: 1, ratedBookBaseId: 1))
        }
        return result
    }
    
    struct PostReview: Encodable {
        var ratedBookBaseId: Int
        var rate: Double
        var body: String
    }
}

