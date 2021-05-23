//
//  Message.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 22.05.2021.
//

import Foundation

struct Message: RemoteEntity {
    var id: Int
    var creationDate: String
    var body: String
    var creatorId: Int
    var receiverId: Int
    var dialogId: Int
    
    static func getItems(amount: Int) -> [Message] {
        var result = [Message]()
        for i in 1...amount {
            result.append(.init(id: i, creationDate: "", body: "Body \(i)", creatorId: 1, receiverId: 2, dialogId: 1))
        }
        return result
    }
    
    static let all = RemoteDataCredentials(endpoint: "message")
}
