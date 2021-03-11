//
//  BookBasePhoto+CoreDataClass.swift
//  BookExchange
//
//  Created by Oleg Koptev on 10.03.2021.
//
//

import Foundation
import CoreData

@objc(BookBasePhoto)
public class BookBasePhoto: NSManagedObject, Decodable {
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else { fatalError() }
        self.init(context: context)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        bookBaseId = try container.decode(Int64.self, forKey: .bookBaseId)
        creationDate = try container.decode(Date.self, forKey: .creationDate)
        creatorId = try container.decode(Int64.self, forKey: .creatorId)
        id = try container.decode(Int64.self, forKey: .id)
        image = try container.decode(String.self, forKey: .image)
    }
}

extension BookBasePhoto {
    enum CodingKeys: String, CodingKey {
        case bookBaseId, creationDate, creatorId, id, image
    }
}
