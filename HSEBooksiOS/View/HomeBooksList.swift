//
//  HomeBooksList.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 15.05.2021.
//

import SwiftUI

struct HomeBooksList: View {
    @ObservedObject var appContext = AppContext.shared
    @StateObject private var viewModel = ViewModel()
    @State private var query: String = ""
    let credentials: RemoteDataCredentials
    var hideHeader: Bool = false
    
    func fetch() {
        viewModel.fetch(to: credentials, with: appContext)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if !hideHeader {
                HeaderWithSearchAndTitle(title: credentials.name)
            }
                
            ScrollView(.vertical) {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.books) { book in
                        Row(bookBase: book, rating: book.rating)
                            .onAppear {
                                if (viewModel.books.last! == book) {
                                    fetch()
                                }
                            }
                    }
                }
                
                if viewModel.viewState == .loading {
                    SpinnerView()
                        .padding(.vertical, 30)
                }
            }
        }
        .overlay(StatusOverlay(viewState: $viewModel.viewState, ignoreLoading: true))
        .onAppear { fetch() }
        .navigationBarHidden(true)
    }
}

extension HomeBooksList {
    struct Row: View {
        @State var bookBase: BookBase
        @State var rating: Double
        
        @ObservedObject var appContext = AppContext.shared
//        @State var isWished: Bool = false
        @State var destinationPresented: Bool = false
        @State var requestIsToPresent: Bool = false
        var body: some View {
            NavigationLink(destination: BookPage(bookBase: $bookBase, rating: $rating, requestPresented: requestIsToPresent), isActive: $destinationPresented) {
                BookListRow(
                    title: bookBase.title,
                    author: bookBase.author,
                    isHearted: appContext.isWished(bookBase),//isWished,
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
            .buttonStyle(PlainButtonStyle())
            .overlay(
                HStack {
                    Spacer()
                    
                    VStack {
                        Menu {
                            Button(
                                (appContext.isWished(bookBase) ? "Remove from wishlist" : "Add to wishlist"),
                                action: {
                                    appContext.toggleWishlist(of: bookBase, viewState: .constant(.none)) { isToAdd in
                                        guard let user = appContext.credentials?.user else { return }
                                        if isToAdd {
                                            bookBase.wishersIds.append(user.id)
                                        } else {
                                            bookBase.wishersIds.removeAll(where: {$0 == user.id})
                                        }
                                    }
                            })
                            
                            Button("Request", action: {
                                requestIsToPresent = true
                                destinationPresented = true
                            })
                            .disabled(bookBase.bookIds.isEmpty)
                        } label: {
                            ZStack {
                                Color.clear
                                    .frame(width: 24, height: 28)
                                Image(systemName: "ellipsis")
                                    .font(.bold(.system(size: 24))())
                                    .rotationEffect(.init(degrees: 90))
                                    .foregroundColor(.primary)
                            }
                        }
                        
                        Spacer()
                    }
                }
                .padding(.top, 14)
                .padding(.trailing, 8)
            )
//            .onAppear {
//                isWished = appContext.isWished(bookBase)
//            }
        }
    }
}

extension HomeBooksList {
    class ViewModel: ObservableObject {
        @Published var books: [BookBase] = []
        @Published var viewState: ViewState = .none
        private var EOF: Bool = false
        
        func fetch(to credentials: RemoteDataCredentials, with appContext: AppContext) {
            guard !appContext.isPreview else {
                books = BookBase.getItems(amount: 5)
                return
            }
            guard viewState != .loading, !EOF else { return }
            guard let token = appContext.credentials?.token else {
                books = []
                viewState = .error("Not Logged In")
                return
            }
            
            viewState = .loading
            
            var params = credentials.params
            params["limit"] = "10"
            params["skip"] = "\(books.count)"
            
            RequestService.shared.makeRequest(to: credentials.endpoint, with: params, using: token) { [weak self] (result: Result<[BookBase], RequestError>) in
                switch result {
                case .failure(let error):
                    self?.viewState = .error(error.description)
                case .success(let books):
                    self?.EOF = books.isEmpty
                    self?.books.append(contentsOf: books)
                    self?.viewState = .none
                }
            }
        }
    }
}


struct HomeBooksList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeBooksList(appContext: .preview, credentials: BookBase.new)
        }
    }
}
