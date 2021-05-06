//
//  MyBooksPage.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 06.05.2021.
//

import SwiftUI

struct MyBooksPage: View {
    @EnvironmentObject var authData: AuthData
    @StateObject var viewModel = MyBooksViewModel()
    
    var body: some View {
        Text("Hello, World!")
    }
}

class MyBooksViewModel: ObservableObject {
    @Published var books: [BookBase] = []
    @Published var viewState: ViewState = .none
    
    
    
    func fetch(with authData: AuthData) {
        guard !authData.isPreview, viewState != .loading else { return }
        guard let token = authData.credentials?.token else {
            books = []
            viewState = .error("Not Logged In")
            return
        }
        
        viewState = .loading
        
        let semaphore = DispatchSemaphore(value: 0)
        
        authData.updateUserInfo { [weak self] result in
            switch result {
            case .failure(let error):
                self?.viewState = .error(error.description)
            case .success(_):
                self?.viewState = .result
            }
            semaphore.signal()
        }
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        guard viewState == .result, let user = authData.credentials?.user else {
            books = []
            viewState = .error("Failed updating user info")
            return
        }
        
        var realBooks: [Book] = []
        let params = ["ids": user.exchangeListIds.map {String($0)}.joined(separator: ",")]
        
        RequestService.shared.makeRequest(to: BookBase.book.endpoint, with: params, using: token) { [weak self] (result: Result<[Book], RequestError>) in
            switch result {
            case .failure(let error):
                self?.viewState = .error(error.description)
            case .success(let books):
                realBooks = books
                self?.viewState = .result
            }
            semaphore.signal()
        }
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        let bookBaseParams = ["ids": realBooks.map { String($0.baseId) }.joined(separator: ",")]
        
        RequestService.shared.makeRequest(to: BookBase.book.endpoint, with: bookBaseParams, using: token) { [weak self] (result: Result<[BookBase], RequestError>) in
            switch result {
            case .failure(let error):
                self?.viewState = .error(error.description)
            case .success(let books):
                self?.books = books
                self?.viewState = .result
            }
        }
    }
}

struct MyBooksPage_Previews: PreviewProvider {
    static var previews: some View {
        MyBooksPage()
    }
}
