//
//  RemoteDataCredentials.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 30.04.2021.
//

import Foundation

struct RemoteDataCredentials {
    let name: String
    let endpoint: String
    var params: [String: String] = [:]
}
