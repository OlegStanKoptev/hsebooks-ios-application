//
//  ExteriorQuality+CoreDataClass.swift
//  BookExchange
//
//  Created by Oleg Koptev on 10.03.2021.
//
//

import Foundation
import CoreData

@objc(ExteriorQuality)
public class ExteriorQuality: NSManagedObject, Decodable {
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else { fatalError() }
        self.init(context: context)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        creationDate = try container.decode(Date.self, forKey: .creationDate)
        id = try container.decode(Int64.self, forKey: .id)
        str = try container.decode(String.self, forKey: .str)
    }
}

extension ExteriorQuality {
    enum CodingKeys: String, CodingKey {
        case creationDate, id, str
    }
}
