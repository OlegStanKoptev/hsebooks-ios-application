//
//  BooksListViewModel.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 02.05.2021.
//

import Foundation

class BooksListViewModel: ObservableObject {
    @Published var books: [BookBase] = []
    @Published var viewState: ViewState = .none
    private var isPreview: Bool = false
    private var endOfData: Bool = false
    let itemsPerLoad = 10
    
    static let preview: BooksListViewModel = {
        let model = BooksListViewModel()
        model.isPreview = true
        model.books = BookBase.getBooks(amount: 10)
        return model
    }()
    
    func fetch(with credentials: RemoteDataCredentials, and auth: AuthData) {
        guard !isPreview, !endOfData else { return }
        guard auth.isLoggedIn, let authToken = auth.token else {
            books = []
            viewState = .error("Not Logged In")
            return
        }
        
        viewState = .loading
        
        var params = credentials.params
        params["skip"] = "\(books.count)"
        params["limit"] = "\(itemsPerLoad)"
        
        RequestService.shared.makeRequest(to: credentials.endpoint, with: params, using: authToken) { (result: Result<[BookBase], RequestService.RequestError>) in
            switch result {
            case .failure(let error):
                self.viewState = .error(error.description)
            case .success(let books):
                self.endOfData = books.isEmpty
                self.books.append(contentsOf: books)
                self.viewState = .result
            }
        }
    }
}
