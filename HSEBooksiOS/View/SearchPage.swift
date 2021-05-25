//
//  SearchPage.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 17.05.2021.
//

import SwiftUI

struct SearchPage: View {
    var onCancel: (() -> Void)?
    var onSelect: ((BookBase) -> Void)?
    
    @ObservedObject var appContext = AppContext.shared
    @StateObject private var viewModel = ViewModel()
    @State var query: String = ""
    
    private func fetch() {
        viewModel.fetch(matches: query, with: appContext)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                SearchBar(query: $query) {
                    fetch()
                } onCancel: {
//                    appContext.searchIsPresented = false
                    onCancel?()
                }
                .padding(.top, 8)
                .padding(.bottom, 8)
                .background(
                    Color.tertiaryColor
                        .edgesIgnoringSafeArea(.top)
                )
                
                ScrollView(.vertical) {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.books) { bookBase in
                            Group {
                                if let onSelect = onSelect {
                                    Button(action: { onSelect(bookBase) }) {
                                        BookListRow(
                                            title: bookBase.title,
                                            author: bookBase.author,
                                            photoId: bookBase.photoId,
                                            coverType: .bookBasePhoto,
                                            thirdLine:
                                                HStack {
                                                    RatingView(value: bookBase.rating)
                                                    Text(bookBase.rating.asStringWithTwoDigits)
                                                },
                                            fourthLine:
                                                Text(bookBase.description ?? "No description available")
                                                .lineLimit(1)
                                                .foregroundColor(.secondary)
                                        )
                                    }
                                } else {
                                    RowWithNavigationLink(bookBase: bookBase, rating: bookBase.rating)
                                }
                            }
                            .onAppear {
                                if bookBase == viewModel.books.last {
                                    fetch()
                                }
                            }
                        }
                        
                        if viewModel.viewState == .loading {
                            SpinnerView()
                        }
                    }
                }
                .overlay(StatusOverlay(viewState: $viewModel.viewState, ignoreLoading: true))
            }
            .navigationBarHidden(true)
        }
    }
}

extension SearchPage {
    struct RowWithNavigationLink: View {
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
                            Text(bookBase.rating.asStringWithTwoDigits)
                        },
                    fourthLine:
                        Text(bookBase.availability)
                        .foregroundColor(bookBase.bookIds.isEmpty ? .red : Color(.lightGray))
                )
            }
        }
    }
}

extension SearchPage {
    class ViewModel: ObservableObject {
        @Published var books: [BookBase] = []
        @Published var viewState: ViewState = .none
        var EOF: Bool = false
        
        func fetch(matches query: String, with appContext: AppContext) {
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
            var params = BookBase.search.params
            params["searchStr"] = query.replacingOccurrences(of: " ", with: "+")
            params["limit"] = "\(10)"
            params["skip"] = "\(books.count)"
            
            RequestService.shared.makeRequest(to: BookBase.search.endpoint, with: params, using: token) { [weak self] (result: Result<[BookBase], RequestError>) in
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

struct SearchResult_Previews: PreviewProvider {
    static var previews: some View {
        SearchPage()
    }
}
