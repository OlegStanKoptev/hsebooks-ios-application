//
//  Complaint.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 24.05.2021.
//

import Foundation

struct Complaint: RemoteEntity {
    var id: Int
    var creationDate: String
    var status: String
    var text: String
    var connectedEntity: BookExchangeRequest?
    var creatorId: Int
    
    static func getItems(amount: Int) -> [Complaint] {
        var result = [Complaint]()
        for i in 1...amount {
            result.append(.init(id: i, creationDate: "", status: "", text: "", connectedEntity: nil, creatorId: 1))
        }
        return result
    }
}
