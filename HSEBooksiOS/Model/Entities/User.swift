//
//  User.swift
//  HSEBooksiOSApp
//
//  Created by Oleg Koptev on 23.04.2021.
//

import Foundation

struct User: RemoteEntity {
    var id: Int
    var creationDate: String
    var role: String
    var username: String
    var name: String
    var townId: Int?
    var bookBaseAddRequestIds: [Int]
    var wishListIds: [Int]
    var complaintsIds: [Int]
    var avatarId: Int?
    var outcomingBookExchangeRequestIds: [Int]
    var incomingBookExchangeRequestIds: [Int]
    var exchangeListIds: [Int]
    
    static func getItems(amount: Int) -> [User] {
        var array = [User]()
        for i in 1...amount {
            array.append(
                User(id: i, creationDate: "2021-04-23T11:55:59.622+00:00", role: "User", username: "Ivanov", name: "Ivan Olegovich", townId: 1, bookBaseAddRequestIds: [], wishListIds: [], complaintsIds: [], avatarId: nil, outcomingBookExchangeRequestIds: [], incomingBookExchangeRequestIds: [], exchangeListIds: [])
            )
        }
        return array
    }
    
    static let `default` = User(id: 2, creationDate: "2021-04-23T11:55:59.622+00:00", role: "Admin", username: "OlegStan", name: "Oleg Koptev", townId: 1, bookBaseAddRequestIds: [], wishListIds: [], complaintsIds: [], avatarId: nil, outcomingBookExchangeRequestIds: [], incomingBookExchangeRequestIds: [], exchangeListIds: [])
    
    
    static let user = RemoteDataCredentials(
        name: "Users",
        endpoint: "user"
    )
    
    static let me = RemoteDataCredentials(
        name: "Me",
        endpoint: "user/me"
    )
    
    static let login = RemoteDataCredentials(
        name: "Log In",
        endpoint: "login"
    )
    
    static let signup = RemoteDataCredentials(
        name: "Sign Up",
        endpoint: "signup"
    )
    
    static let wishlist = RemoteDataCredentials(
        name: "Wishlist",
        endpoint: "user/wishlist"
    )
}
