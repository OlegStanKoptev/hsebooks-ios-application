//
//  WishedBooksListViewModel.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 02.05.2021.
//

import Foundation

class WishedBooksListViewModel: ObservableObject {
    @Published var wishlist: [BookBase] = []
    @Published var viewState: ViewState = .none
    private var isPreview = false
    
    static var preview: WishedBooksListViewModel = {
        let model = WishedBooksListViewModel()
        model.isPreview = true
        model.wishlist = BookBase.getBooks(amount: 5)
        return model
    }()
    
    func fetch(with credentials: RemoteDataCredentials, and auth: AuthData) {
        guard !isPreview else { return }
        guard auth.isLoggedIn, let authToken = auth.token, let user = auth.currentUser else {
            wishlist = []
            viewState = .error("Not Logged In")
            return
        }
        
        viewState = .loading
        var params = credentials.params
        params["ids"] = user.wishListIds.map { String($0) }.joined(separator: ",")
        
        RequestService.shared.makeRequest(to: "bookBase", with: params, using: authToken) { (result: Result<[BookBase], RequestService.RequestError>) in
            switch result {
            case .failure(let error):
                self.viewState = .error(error.description)
            case .success(let books):
                self.wishlist = books
                self.viewState = .result
            }
        }
    }
}
