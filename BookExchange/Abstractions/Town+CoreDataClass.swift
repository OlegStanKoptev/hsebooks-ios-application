//
//  Town+CoreDataClass.swift
//  BookExchange
//
//  Created by Oleg Koptev on 10.03.2021.
//
//

import Foundation
import CoreData

@objc(Town)
public class Town: NSManagedObject, Decodable {
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else { fatalError() }
        self.init(context: context)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        books = try container.decode([Int64].self, forKey: .books)
        creationDate = try container.decode(Date.self, forKey: .creationDate)
        id = try container.decode(Int64.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
    }
}

extension Town {
    enum CodingKeys: String, CodingKey {
        case books, creationDate, id, name
    }
}
