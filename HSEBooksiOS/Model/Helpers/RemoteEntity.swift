//
//  RemoteEntity.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 04.05.2021.
//

import Foundation

protocol RemoteEntity: Identifiable, Equatable, Decodable {
    static func getItems(amount: Int) -> [Self]
}
