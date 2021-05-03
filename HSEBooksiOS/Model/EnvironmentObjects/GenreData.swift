//
//  GenreData.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 02.05.2021.
//

import Foundation

class GenreData: ObservableObject {
    @Published var genres: [Genre] = []
    @Published var viewState = ViewState.none
    private var isPreview: Bool = false
    
    static let preview: GenreData = {
        let model = GenreData()
        model.isPreview = true
        model.genres = Genre.getGenres(amount: 5)
        return model
    }()
    
    func fetch(with auth: AuthData) {
        guard !isPreview, viewState != .result, viewState != .loading else { return }
        guard let authToken = auth.token, auth.isLoggedIn else {
            genres = []
            viewState = .error("Not Logged In")
            return
        }
        
        viewState = .loading
        
        RequestService.shared.makeRequest(to: Genre.all.endpoint, using: authToken) { (result: Result<[Genre], RequestService.RequestError>) in
            switch result {
            case .failure(let error):
                self.viewState = .error(error.description)
            case .success(let genres):
                self.genres = genres
                self.viewState = .result
            }
        }
    }
}
