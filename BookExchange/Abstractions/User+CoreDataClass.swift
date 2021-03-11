//
//  User+CoreDataClass.swift
//  BookExchange
//
//  Created by Oleg Koptev on 10.03.2021.
//
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject, Decodable {
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else { fatalError() }
        self.init(context: context)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        avatarId = try container.decode(Int64.self, forKey: .avatarId)
        complaintsIds = try container.decode([Int64].self, forKey: .complaintsIds)
        creationDate = try container.decode(Date.self, forKey: .creationDate)
        exchangeListIds = try container.decode([Int64].self, forKey: .exchangeListIds)
        id = try container.decode(Int64.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        requestsIds = try container.decode([Int64].self, forKey: .requestsIds)
        username = try container.decode(String.self, forKey: .username)
        wishListIds = try container.decode([Int64].self, forKey: .wishListIds)
    }
}

extension User {
    enum CodingKeys: String, CodingKey {
        case avatarId, complaintsIds, creationDate, exchangeListIds, id, name, requestsIds, username, wishListIds
    }
}
