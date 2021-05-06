//
//  HomePageViewModel.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 06.05.2021.
//

import Foundation

extension HomePage {
    class HomePageViewModel: ObservableObject {
        @Published private(set) var sections: [(header: String, books: [BookBase])] = []
        @Published private(set) var viewState: ViewState = .none
        private let queue = DispatchQueue(label: "HomePageSectionsLoading")
        private var isPreview = false
        
        func fetch(with authData: AuthData) {
            guard !isPreview else { return }
            guard authData.isLoggedIn, let token = authData.credentials?.token else {
                sections = []
                viewState = .error("Not Logged In")
                return
            }
            
            viewState = .loading
            
            let group = DispatchGroup()
            var result: Result<[(String, [BookBase])], RequestError>!
            
            for section in BookBase.home.sections {
                queue.async {
                    RequestService.shared.makeRequest(to: section.endpoint, with: section.params, using: token) { (requestResult: Result<[BookBase], RequestError>) in
//                        switch requestResult {
//                        case .failure(let error):
//                            result = .failure(error)
//                        case .success(let books):
//                            result.flatMap { <#[(String, [BookBase])]#> in
//                                <#code#>
//                            }
//                        }
                    }
                }
            }

            group.wait()

            print("All tasks done")
        }
    }
}

extension HomePage.HomePageViewModel {
    static let preview: HomePage.HomePageViewModel = {
        let model = HomePage.HomePageViewModel()
        model.isPreview = true
        return model
    }()
}
