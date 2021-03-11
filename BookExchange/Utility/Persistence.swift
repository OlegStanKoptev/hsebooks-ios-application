//
//  Persistence.swift
//  BookExchange
//
//  Created by Oleg Koptev on 09.03.2021.
//

import Foundation
import CoreData

struct PersistenceController {
    static let shared = PersistenceController(inMemory: true)

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext

        var names: [String] = []
        for i in 1...10 {
            names.append("Book \(i)")
        }
        
        for name in names {
            let book = BookBase(context: viewContext)
            book.title = name
        }
        
        result.save()

        return result
    }()
    
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "BookExchange")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Unresolved error: \(error), \(error.userInfo)")
            }
        }
    }
    
    func save() {
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Error: \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}
