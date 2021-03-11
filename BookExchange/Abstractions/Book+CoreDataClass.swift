//
//  Book+CoreDataClass.swift
//  BookExchange
//
//  Created by Oleg Koptev on 10.03.2021.
//
//

import Foundation
import CoreData

@objc(Book)
public class Book: NSManagedObject, Decodable {
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else { fatalError() }
        self.init(context: context)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        baseId = try container.decode(Int64.self, forKey: .baseId)
        creationDate = try container.decode(Date.self, forKey: .creationDate)
        creatorId = try container.decode(Int64.self, forKey: .creatorId)
        exteriorQualityId = try container.decode(Int64.self, forKey: .exteriorQualityId)
        id = try container.decode(Int64.self, forKey: .id)
        photoId = try container.decode(Int64.self, forKey: .photoId)
        townId = try container.decode(Int64.self, forKey: .townId)
    }
}

extension Book {
    enum CodingKeys: String, CodingKey {
        case baseId, creationDate, creatorId, exteriorQualityId, id, photoId, townId
    }
}
