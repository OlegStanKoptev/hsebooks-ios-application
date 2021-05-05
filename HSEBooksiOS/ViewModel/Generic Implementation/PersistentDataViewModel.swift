//
//  PersistentDataViewModel.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 04.05.2021.
//

import Foundation

class PersistentDataViewModel<Item: RemoteEntity>: ViewModel {
    @Published var items: [Item] = []
    @Published var viewState: ViewState = .none
    func fetch(from credentials: RemoteDataCredentials, with appState: AppState) {}
    func clearCache() { items = []; viewState = .none }
}

class RealPersistentDataViewModel<Item: RemoteEntity>: PersistentDataViewModel<Item> {
    override func fetch(from credentials: RemoteDataCredentials, with appState: AppState) {
        guard !appState.isPreview, items.isEmpty, viewState != .result, viewState != .loading else { return }
        guard let authToken = appState.authData.token, appState.authData.isLoggedIn else {
            items = []
            viewState = .error("Not Logged In")
            return
        }

        viewState = .loading

        RequestService.shared.makeRequest(to: credentials.endpoint, using: authToken) { [weak self] (result: Result<[Item], RequestError>) in
            switch result {
            case .failure(let error):
                self?.viewState = .error(error.description)
            case .success(let items):
                self?.items = items
                self?.viewState = .result
            }
        }
    }
}

class MockPersistentDataViewModel<Item: RemoteEntity>: PersistentDataViewModel<Item> {
    override init() {
        super.init()
        items = Item.getItems(amount: 5)
        viewState = .result
    }
}
