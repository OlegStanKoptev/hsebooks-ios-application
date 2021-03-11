//
//  BookBase+CoreDataClass.swift
//  BookExchange
//
//  Created by Oleg Koptev on 10.03.2021.
//
//

import Foundation
import CoreData

@objc(BookBase)
public class BookBase: NSManagedObject, Decodable {
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else { fatalError() }
        self.init(context: context)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        author = try container.decode(String.self, forKey: .author)
        bookIds = try container.decode([Int64].self, forKey: .bookIds)
        creationDate = try container.decode(Date.self, forKey: .creationDate)
        description_ = try container.decode(String.self, forKey: .description_)
        genreIds = try container.decode([Int64].self, forKey: .genreIds)
        id = try container.decode(Int64.self, forKey: .id)
        language = try container.decode(String.self, forKey: .language)
        numberOfPages = try container.decode(Int32.self, forKey: .numberOfPages)
        photoId = try container.decode(Int64.self, forKey: .photoId)
        publishYear = try container.decode(Int32.self, forKey: .publishYear)
        rating = try container.decode(Double.self, forKey: .rating)
        title = try container.decode(String.self, forKey: .title)
        wishersIds = try container.decode([Int64].self, forKey: .wishersIds)
    }
}

extension BookBase {
    public enum CodingKeys: String, CodingKey {
        case author, bookIds, creationDate, genreIds, id, language, numberOfPages, photoId, publishYear, rating, title, wishersIds
        case description_ = "description"
    }
}

extension BookBase {
    static func booksOnHomeScreen() -> NSFetchRequest<BookBase> {
        let request: NSFetchRequest<BookBase> = BookBase.fetchRequest()
        request.fetchLimit = 3
        request.sortDescriptors = [NSSortDescriptor(keyPath: \BookBase.title, ascending: true)]
        return request
    }
}
