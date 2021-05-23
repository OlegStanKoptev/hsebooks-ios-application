//
//  Dialog.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 22.05.2021.
//

import Foundation

struct Dialog: RemoteEntity {
    var id: Int
    var creationDate: String
    var exchangeRequestId: Int
    var participantIds: [Int]
    var messageIds: [Int]
    
    static func getItems(amount: Int) -> [Dialog] {
        var result = [Dialog]()
        for i in 1...amount {
            result.append(.init(id: i, creationDate: "", exchangeRequestId: 1, participantIds: [], messageIds: []))
        }
        return result
    }
    
    static let all = RemoteDataCredentials(endpoint: "dialog")
}
