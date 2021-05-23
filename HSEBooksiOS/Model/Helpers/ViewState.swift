//
//  ViewState.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 30.04.2021.
//

import Foundation

enum ViewState: Equatable {
    case none
    case loading
    case error(String)
}
