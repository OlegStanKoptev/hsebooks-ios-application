//
//  RemoteDataCredentials.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 30.04.2021.
//

import Foundation

struct RemoteDataCredentials {
    var name: String = ""
    let endpoint: String
    var params: [String: String] = [:]
}
