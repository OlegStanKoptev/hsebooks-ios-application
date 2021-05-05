//
//  BooksListViewModel.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 02.05.2021.
//

import Foundation

class DynamicDataViewModel<Item: RemoteEntity>: ViewModel {
    @Published var items: [Item] = []
    @Published var viewState: ViewState = .none
    func fetch(from credentials: RemoteDataCredentials, with appState: AppState) {}
    func clearCache() { items = []; viewState = .none }
}

class RealDynamicDataViewModel<Item: RemoteEntity>: DynamicDataViewModel<Item> {
    private var endOfData: Bool = false
    private let itemsPerLoad = 10
    
    override func fetch(from credentials: RemoteDataCredentials, with appState: AppState) {
        guard !appState.isPreview, !endOfData else { return }
        guard appState.authData.isLoggedIn, let authToken = appState.authData.token else {
            items = []
            viewState = .error("Not Logged In")
            return
        }

        viewState = .loading

        var params = credentials.params
        params["skip"] = "\(items.count)"
        params["limit"] = "\(itemsPerLoad)"

        RequestService.shared.makeRequest(to: credentials.endpoint, with: params, using: authToken) { [weak self] (result: Result<[Item], RequestError>) in
            switch result {
            case .failure(let error):
                self?.viewState = .error(error.description)
            case .success(let items):
                if !items.isEmpty {
                    if !(self?.items.contains(items.first!) ?? true) {
                        self?.items.append(contentsOf: items)
                    }
                } else {
                    self?.endOfData = true
                }
                self?.viewState = .result
            }
        }
    }
}

class MockDynamicDataViewModel<Item: RemoteEntity>: DynamicDataViewModel<Item> {
    override init() {
        super.init()
        items = Item.getItems(amount: 5)
        viewState = .result
    }
}
