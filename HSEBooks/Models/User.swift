//
//  User.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 03.04.2021.
//

import Foundation

struct User: Identifiable, Decodable {
    var id: Int
    var creationDate: String
    var role: String
    var username: String
    var name: String
    var wishListIds: [Int]
    var bookBaseAddRequestIds: [Int]
    var complaintsIds: [Int]
    var avatarId: Int?
    var outcomingBookExchangeRequestIds: [Int]
    var incomingBookExchangeRequestIds: [Int]
    var exchangeListIds: [Int]
    
    static var defaultAdminUser: User {
        User(id: 2, creationDate: "2021-04-03T09:40:00.068+00:00", role: "Admin", username: "OlegStan", name: "Oleg Koptev", wishListIds: [], bookBaseAddRequestIds: [], complaintsIds: [], avatarId: nil, outcomingBookExchangeRequestIds: [], incomingBookExchangeRequestIds: [], exchangeListIds: [])
    }
}
