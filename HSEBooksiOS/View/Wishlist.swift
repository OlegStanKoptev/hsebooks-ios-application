//
//  Wishlist.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 21.05.2021.
//

import SwiftUI

struct Wishlist: View {
    @ObservedObject var appContext = AppContext.shared
    @StateObject var viewModel = ViewModel()
    
    private func fetch() {
        viewModel.fetch(with: appContext)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderWithSearchAndTitle(title: "Wishlist")
                
            ScrollView(.vertical) {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.books) { bookBase in
                        Row(bookBase: bookBase, rating: bookBase.rating)
                    }
                }
                
                if viewModel.viewState == .loading {
                    SpinnerView()
                        .padding(.vertical, 30)
                }
            }
            .disabled(viewModel.viewState == .loading)
        }
        .onAppear { fetch() }
        .navigationBarHidden(true)
    }
}

extension Wishlist {
    struct Row: View {
        @State var bookBase: BookBase
        @State var rating: Double
        var body: some View {
            NavigationLink(destination: BookPage(bookBase: $bookBase, rating: $rating)) {
                BookListRow(
                    title: bookBase.title,
                    author: bookBase.author,
                    photoId: bookBase.photoId,
                    coverType: .bookBasePhoto,
                    thirdLine:
                        HStack {
                            RatingView(value: rating)
                            Text(rating.asStringWithTwoDigits)
                        },
                    fourthLine:
                        Text(bookBase.availability)
                        .foregroundColor(bookBase.bookIds.isEmpty ? .red : Color(.lightGray))
                )
            }
        }
    }
}

extension Wishlist {
    class ViewModel: ObservableObject {
        @Published var books: [BookBase] = []
        @Published var viewState: ViewState = .none
        
        func fetch(with context: AppContext) {
            guard !context.isPreview else {
                books = BookBase.getItems(amount: 5)
                return
            }
            guard viewState != .loading else { return }
            guard context.credentials != nil else {
                viewState = .error("Not Logged In")
                return
            }
            
            viewState = .loading
            
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                let semaphore = DispatchSemaphore(value: 0)
                context.updateUserInfo { [weak self] result in
                    switch result {
                    case .failure(let error):
                        self?.viewState = .error(error.description)
                    case .success(_): break
                    }
                    semaphore.signal()
                }
                semaphore.wait()
                guard let credentials = context.credentials else { return }
            
                let params = [
                    "ids": credentials.user.wishListIds
                        .map{String($0)}
                        .joined(separator: ",")
                ]
                
                RequestService.shared.makeRequest(to: BookBase.book.endpoint, with: params, using: credentials.token) { [weak self] (result: Result<[BookBase], RequestError>) in
                    switch result {
                    case .failure(let error):
                        self?.viewState = .error(error.description)
                    case .success(let data):
                        self?.books = data
                        self?.viewState = .none
                    }
                }
            }
        }
    }
}

struct Wishlist_Previews: PreviewProvider {
    static var previews: some View {
        Wishlist()
    }
}
