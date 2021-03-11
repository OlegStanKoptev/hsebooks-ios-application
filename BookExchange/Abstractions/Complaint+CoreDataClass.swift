//
//  Complaint+CoreDataClass.swift
//  BookExchange
//
//  Created by Oleg Koptev on 10.03.2021.
//
//

import Foundation
import CoreData

@objc(Complaint)
public class Complaint: NSManagedObject, Decodable {
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else { fatalError() }
        self.init(context: context)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        creationDate = try container.decode(Date.self, forKey: .creationDate)
        creatorId = try container.decode(Int64.self, forKey: .creatorId)
        id = try container.decode(Int64.self, forKey: .id)
        status = try container.decode(String.self, forKey: .status)
        text = try container.decode(String.self, forKey: .text)
    }
}

extension Complaint {
    enum CodingKeys: String, CodingKey {
        case creationDate, creatorId, id, status, text
    }
}
