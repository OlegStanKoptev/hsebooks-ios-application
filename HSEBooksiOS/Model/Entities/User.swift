//
//  User.swift
//  HSEBooksiOSApp
//
//  Created by Oleg Koptev on 23.04.2021.
//

import Foundation

struct User: Identifiable, Decodable {
    var id: Int
    var creationDate: String
    var role: String
    var username: String
    var name: String
    var bookBaseAddRequestIds: [Int]
    var wishListIds: [Int]
    var complaintsIds: [Int]
    var avatarId: Int?
    var outcomingBookExchangeRequestIds: [Int]
    var incomingBookExchangeRequestIds: [Int]
    var exchangeListIds: [Int]
    
    static let `default` = User(id: 2, creationDate: "2021-04-23T11:55:59.622+00:00", role: "Admin", username: "OlegStan", name: "Oleg Koptev", bookBaseAddRequestIds: [], wishListIds: [], complaintsIds: [], avatarId: nil, outcomingBookExchangeRequestIds: [], incomingBookExchangeRequestIds: [], exchangeListIds: [])
    
    
    static let all = RemoteDataCredentials(
        name: "All Users",
        endpoint: "user"
    )
    
    static let login = RemoteDataCredentials(
        name: "Log In",
        endpoint: "login"
    )
    
    static let signup = RemoteDataCredentials(
        name: "Sign Up",
        endpoint: "signup"
    )
}
