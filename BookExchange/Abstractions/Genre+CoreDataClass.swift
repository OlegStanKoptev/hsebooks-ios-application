//
//  Genre+CoreDataClass.swift
//  BookExchange
//
//  Created by Oleg Koptev on 10.03.2021.
//
//

import Foundation
import CoreData

@objc(Genre)
public class Genre: NSManagedObject, Decodable {
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else { fatalError() }
        self.init(context: context)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        bookBases = try container.decode([Int64].self, forKey: .bookBases)
        creationDate = try container.decode(Date.self, forKey: .creationDate)
        id = try container.decode(Int64.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
    }
}

extension Genre {
    enum CodingKeys: String, CodingKey {
        case bookBases, creationDate, id, name
    }
}
