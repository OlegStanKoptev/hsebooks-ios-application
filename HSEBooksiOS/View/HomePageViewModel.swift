//
//  HomePageViewModel.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 06.05.2021.
//

import Foundation

extension HomePage {
    class HomePageViewModel: ObservableObject {
        @Published private(set) var sections: [(RemoteDataCredentials, [BookBase])] = []
        @Published var viewState: ViewState = .none
        private let queue = DispatchQueue(label: "HomePageSectionsLoading")
        
        func fetch(with authData: AuthData) {
            guard !authData.isPreview else {
                sections = [
                    (BookBase.new, BookBase.getItems(amount: 3)),
                    (BookBase.recommended, BookBase.getItems(amount: 3)),
                    (BookBase.rate, BookBase.getItems(amount: 3))
                ]
                return
            }
            guard viewState != .loading else { return }
            guard authData.isLoggedIn, let token = authData.credentials?.token else {
                sections = []
                viewState = .error("Not Logged In")
                return
            }
            
            viewState = .loading
            
            DispatchQueue.global().async {
                <#code#>
            }
            
//            DispatchQueue.global().async {
//                let group = DispatchGroup()
//                var result: Result<[(RemoteDataCredentials, [BookBase])], RequestError> = .success([])
//
//                for section in BookBase.home.sections {
//                    self.queue.async {
//                        var params = section.params
//                        params["limit"] = "3"
//
//                        let semaphore = DispatchSemaphore(value: 0)
//
//                        RequestService.shared.makeRequest(to: section.endpoint, with: params, using: token) { (requestResult: Result<[BookBase], RequestError>) in
//                            switch requestResult {
//                            case .failure(let error):
//                                result = .failure(error)
//                            case .success(let books):
//                                switch result {
//                                case .failure(_):
//                                    return
//                                case .success(let oldResult):
//                                    var newData = oldResult
//                                    newData.append((section, books))
//                                    result = .success(newData)
//                                }
//                            }
//                            semaphore.signal()
//                        }
//
//                        _ = semaphore.wait(timeout: .distantFuture)
//                    }
//                }
//
//                group.wait()
//
//                DispatchQueue.main.async {
//                    switch result {
//                    case .failure(let error):
//                        self.viewState = .error(error.description)
//                    case .success(let data):
//                        self.sections = data
//                        self.viewState = .result
//                    }
//                }
//
//                print("All tasks done")
//            }
        }
    }
}

//extension HomePage.HomePageViewModel {
//    static let preview: HomePage.HomePageViewModel = {
//        let model = HomePage.HomePageViewModel()
//        model.isPreview = true
//        model.sections = [
//            ("Title 1", BookBase.getItems(amount: 3)),
//            ("Title 2", BookBase.getItems(amount: 3)),
//            ("Title 3", BookBase.getItems(amount: 3))
//        ]
//        return model
//    }()
//}
