//
//  BookExchangeRequest.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 06.05.2021.
//

import Foundation

struct BookExchangeRequest: RemoteEntity {
    var id: Int
    var creationDate: String
    var status: RequestStatus
    var userFromId: Int
    var userToId: Int
    var exchangingBookId: Int
    var dialogId: Int
    var creatorId: Int
    
    static func getItems(amount: Int) -> [BookExchangeRequest] {
        var result = [BookExchangeRequest]()
        for i in 1...amount {
            result.append(.init(id: i, creationDate: "2021-05-06T20:15:55.724+00:00", status: .Pending, userFromId: 10, userToId: 6, exchangingBookId: 51, dialogId: 1, creatorId: 10))
        }
        return result
    }
    
    static let request = RemoteDataCredentials(
        name: "Book Exchange Request",
        endpoint: "book/request"
    )
    
    static func complaint(for id: Int) -> RemoteDataCredentials {
        RemoteDataCredentials(endpoint: "book/request/\(id)/addComplaint")
    }
}
