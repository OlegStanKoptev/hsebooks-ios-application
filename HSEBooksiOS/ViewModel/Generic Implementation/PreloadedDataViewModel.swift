//
//  WishedBooksListViewModel.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 02.05.2021.
//

import Foundation

class PreloadedDataViewModel<Item: RemoteEntity>: ViewModel {
    @Published var items: [Item] = []
    @Published var viewState: ViewState = .none
    func fetch(_ ids: [Int]?, from credentials: RemoteDataCredentials, with appState: AppState) {}
    func clearCache() { items = []; viewState = .none }
}

class RealPreloadedDataViewModel<Item: RemoteEntity>: PreloadedDataViewModel<Item> {
    override func fetch(_ ids: [Int]?, from credentials: RemoteDataCredentials, with appState: AppState) {
        guard !appState.isPreview, viewState != .loading else { return }
        guard appState.authData.isLoggedIn, let ids = ids, let authToken = appState.authData.token else {
            items = []
            viewState = .error("Not Logged In")
            return
        }
        
        viewState = .loading
        
        if ids.isEmpty {
            self.items = []
            self.viewState = .result
            return
        }
        
        DispatchQueue.global().async {
            let semaphore = DispatchSemaphore(value: 0)
            
            appState.authData.updateProfileInfo {
                semaphore.signal()
            }
            
            _ = semaphore.wait(wallTimeout: .distantFuture)
            guard appState.authData.authState == .result else { return }
            
            var params = credentials.params
            params["ids"] = ids.map { String($0) }.joined(separator: ",")
    
            RequestService.shared.makeRequest(to: "bookBase", with: params, using: authToken) { [weak self] (result: Result<[Item], RequestError>) in
                switch result {
                case .failure(let error):
                    self?.viewState = .error(error.description)
                case .success(let books):
                    self?.items = books
                    self?.viewState = .result
                }
            }
        }
        

    }
}

class MockPreloadedDataViewModel<Item: RemoteEntity>: PreloadedDataViewModel<Item> {
    override init() {
        super.init()
        items = Item.getItems(amount: 5)
        viewState = .result
    }
}
