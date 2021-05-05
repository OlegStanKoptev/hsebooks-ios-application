//
//  HomeData.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 04.05.2021.
//

import Foundation

class HomeData: ObservableObject {
    @Published var sections: [(RemoteDataCredentials, [BookBase])] = []
    @Published var viewState: ViewState = .none
    private var isPreview: Bool = false
    
    static let preview: HomeData = {
        let model = HomeData()
        model.isPreview = true
        model.sections = [
            (BookBase.new, BookBase.getItems(amount: 3))
        ]
        return model
    }()
    
    private func loadBooks(_ credentials: RemoteDataCredentials, with authToken: String, previousData: [(RemoteDataCredentials, [BookBase])] = []) -> Result<[(RemoteDataCredentials, [BookBase])], RequestError> {
        var result: Result<[(RemoteDataCredentials, [BookBase])], RequestError>!
        let semaphore = DispatchSemaphore(value: 0)
        
        var params = credentials.params
        params["limit"] = "3"
        
        RequestService.shared.makeRequest(to: credentials.endpoint, with: params, using: authToken) { (localResult: Result<[BookBase], RequestError>) in
            switch localResult {
            case .failure(let error):
                result = .failure(error)
            case .success(let books):
                var newData = previousData
                newData.append((credentials, books))
                result = .success(newData)
            }
            semaphore.signal()
        }
        
        _ = semaphore.wait(wallTimeout: .distantFuture)
        return result
    }
    
    func fetch(with auth: AuthData) {
        guard !isPreview, viewState != .loading, viewState != .result else { return }
        guard let authToken = auth.token, auth.isLoggedIn else {
            sections = []
            viewState = .error("Not Logged In")
            return
        }
        
        viewState = .loading
        
        DispatchQueue.global(qos: .userInteractive).async {
            var result: Result<[(RemoteDataCredentials, [BookBase])], RequestError> = .success([])
            for section in BookBase.home.sections {
                result = result.flatMap { self.loadBooks(section, with: authToken, previousData: $0) }
            }
            
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    self.viewState = .error(error.description)
                case .success(let books):
                    self.sections = books
                    self.viewState = .result
                }
            }
        }
    }
    
    func clearCache() {
        sections = []
        viewState = .none
    }
}
