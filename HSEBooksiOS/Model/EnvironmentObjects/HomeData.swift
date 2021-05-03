//
//  HomeData.swift
//  HSEBooksiOSApp
//
//  Created by Oleg Koptev on 23.04.2021.
//

import Foundation

class HomeData: ObservableObject {
    @Published var books: [(RemoteDataCredentials, [BookBase])] = []
    @Published var viewState: ViewState = .none
    private var isPreview: Bool = false
    
    static let preview: HomeData = {
        let model = HomeData()
        model.isPreview = true
        model.books = [
            (BookBase.new, BookBase.getBooks(amount: 3))
        ]
        return model
    }()
    
    private func loadBooks(_ credentials: RemoteDataCredentials, with authToken: String, previousData: [(RemoteDataCredentials, [BookBase])] = []) -> Result<[(RemoteDataCredentials, [BookBase])], RequestService.RequestError> {
        var result: Result<[(RemoteDataCredentials, [BookBase])], RequestService.RequestError>!
        let semaphore = DispatchSemaphore(value: 0)
        
        var params = credentials.params
        params["limit"] = "3"
        
        RequestService.shared.makeRequest(to: credentials.endpoint, with: params, using: authToken) { (localResult: Result<[BookBase], RequestService.RequestError>) in
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
            books = []
            viewState = .error("Not Logged In")
            return
        }
        
        viewState = .loading
        
        DispatchQueue.global(qos: .userInteractive).async {
            var result: Result<[(RemoteDataCredentials, [BookBase])], RequestService.RequestError> = .success([])
            for section in BookBase.home.sections {
                result = result.flatMap { self.loadBooks(section, with: authToken, previousData: $0) }
            }
            
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    self.viewState = .error(error.description)
                case .success(let books):
                    self.books = books
                    self.viewState = .result
                }
            }
        }
    }
}
