//
//  ViewModel.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 04.05.2021.
//

import Foundation

protocol ViewModel: ObservableObject {
    associatedtype Item: RemoteEntity
    var items: [Item] { get }
    var viewState: ViewState { get }
}
