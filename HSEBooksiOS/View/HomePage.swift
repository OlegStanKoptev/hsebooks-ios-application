//
//  HomePage.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 29.04.2021.
//

import SwiftUI

enum HomePageTab: String, CaseIterable, Equatable {
    case genre
    case whatToRead = "What To Read"
    case new
    case recommended
    case mostRated = "Most Rated"
}

struct HomePage: View {
    @ObservedObject var appContext = AppContext.shared
    @State var currentTab: HomePageTab = .whatToRead
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                SearchBarButton()
                    .padding(.bottom, 8)
                    .background(
                        Color.tertiaryColor
                            .edgesIgnoringSafeArea(.top)
                    )
                
                VStack(spacing: 0) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(HomePageTab.allCases, id: \.rawValue) { tab in
                                Button(action: { currentTab = tab }) {
                                    Text(tab.rawValue)
                                        .foregroundColor(tab == currentTab ? .accentColor : .white)
                                }
                            }
                        }
                        .font(.system(size: UIFont.preferredFont(forTextStyle: .body).pointSize - 2))
                        .textCase(.uppercase)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 4)
                    }
                    .background(
                        Color.tertiaryColor
                    )
                    
                    Spacer(minLength: 0)
                    Group {
                        switch currentTab {
                        case .genre:
                            GenresTab()
                        case .whatToRead:
                            WhatToReadTab()
                        case .new:
                            HomeBooksList(credentials: BookBase.new, hideHeader: true)
                        case .recommended:
                            HomeBooksList(credentials: BookBase.recommended, hideHeader: true)
                        case .mostRated:
                            HomeBooksList(credentials: BookBase.rate, hideHeader: true)
                        }
                    }
                    Spacer(minLength: 0)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

extension HomePage {
    struct WhatToReadTab: View {
        @ObservedObject var appContext = AppContext.shared
        @StateObject var viewModel = ViewModel()
        
        func fetchData() {
            viewModel.fetch(with: appContext)
        }
        
        var body: some View {
            ScrollView(.vertical) {
                ForEach(viewModel.sections, id: \.0.name) { row in
                    ThreeBooksSectionWithHeader(credentials: row.0) {
                        ForEach(row.1) { item in
                            ThreeBooksSectionItemLink(bookBase: item, rating: item.rating)
                        }
                    }
                    .padding(.bottom, 8)
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .overlay(
                Group {
                    if viewModel.sections.isEmpty || viewModel.viewState != .loading {
                        StatusOverlay(viewState: $viewModel.viewState, ignoreError: true)
                    }
                }
            )
            .onChange(of: appContext.credentials != nil) { notNull in
                if notNull { fetchData() }
            }
            .onChange(of: appContext.isLoggedIn) { value in
                if (value) { fetchData() }
            }
            .onAppear {
                fetchData()
            }
        }
    }
}

extension HomePage {
    struct GenresTab: View {
        @ObservedObject var appContext = AppContext.shared
        var body: some View {
            VStack(spacing: 0) {
                ScrollView(.vertical) {
                    VStack(spacing: 0) {
                        ForEach(appContext.genres) { item in
                            VStack(spacing: 0) {
                                NavigationLink(
                                    destination: HomeBooksList(credentials: Genre.genreCredentials(for: item.id, title: item.name)),
                                    label: {
                                        HStack(spacing: 0) {
                                            Text(item.name)
                                                .foregroundColor(.primary)
                                                .padding(.vertical, 10)
                                            Spacer()
                                            Image(systemName: "chevron.forward")
                                                .foregroundColor(.secondary)
                                        }
                                        .padding(.horizontal, 16)
                                    })
                                
                                Rectangle()
                                    .fill(Color(.separator))
                                    .frame(height: 1)
                            }
                        }
                    }
                }
            }
        }
    }
}

extension HomePage {
    struct ThreeBooksSectionItemLink: View {
        @State var bookBase: BookBase
        @State var rating: Double
        var body: some View {
            NavigationLink(destination: BookPage(bookBase: $bookBase, rating: $rating)) {
                ThreeBooksSectionItem(title: bookBase.title, author: bookBase.author, rating: rating, publishYear: bookBase.publishYear, photoId: bookBase.photoId)
            }
        }
    }
}

struct ThreeBooksSectionWithHeader<Content: View>: View {
    let credentials: RemoteDataCredentials
    let content: Content
    var body: some View {
        VStack {
            NavigationLink(destination: HomeBooksList(credentials: credentials)) {
                HStack(spacing: 4) {
                    Text(credentials.name)
                        .font(.system(size: 15))
                        .textCase(.uppercase)
                        .foregroundColor(.orange)
                    Image(systemName: "chevron.forward")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
            HStack {
                content
            }
        }
    }
}

extension ThreeBooksSectionWithHeader {
    init(credentials: RemoteDataCredentials, @ViewBuilder content: () -> Content) {
        self.credentials = credentials
        self.content = content()
    }
}

struct ThreeBooksSectionItem: View {
    var title: String = "Title"
    var author: String = "Author"
    var rating: Double = 5.0
    var publishYear: Int = 2021
    var photoId: Int? = nil
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            BookCover(id: photoId, type: .bookBasePhoto)
            HStack {
                HStack(spacing: 2) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.accentColor)
                        .font(.system(size: 10))
                    Text(rating.asStringWithTwoDigits)
                }
                HStack(spacing: 2) {
                    Image(systemName: "calendar.circle.fill")
                        .foregroundColor(.accentColor)
                        .font(.system(size: 10))
                    Text(String(publishYear))
                }
                Spacer(minLength: 0)
            }
            .foregroundColor(.white)
            .padding(.vertical, 2)
            .padding(.horizontal, 4)
            .background(Color.tertiaryColor)
            VStack(alignment: .leading) {
                Text(author)
                    .foregroundColor(.secondary)
                Text(title)
            }
            .padding(.horizontal, 4)
            .padding(2)
        }
        .padding(.bottom, 4)
        .lineLimit(1)
        .foregroundColor(.primary)
        .font(.system(size: 12))
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.white)
                    .shadow(radius: 2)
                RoundedRectangle(cornerRadius: 6)
                    .strokeBorder(Color(.systemGray6), lineWidth: 1.0, antialiased: true)
            }
        )
    }
}

extension HomePage.WhatToReadTab {
    class ViewModel: ObservableObject {
        @Published private(set) var sections: [(RemoteDataCredentials, [BookBase])] = []
        @Published var viewState: ViewState = .none
        private let queue = DispatchQueue(label: "HomePageSectionsLoading")
        
        private func loadBooks(_ credentials: RemoteDataCredentials, with authToken: String, previousData: [(RemoteDataCredentials, [BookBase])] = []) -> Result<[(RemoteDataCredentials, [BookBase])], RequestError> {
            var result: Result<[(RemoteDataCredentials, [BookBase])], RequestError>!
            let semaphore = DispatchSemaphore(value: 0)
            
            var params = credentials.params
            params["limit"] = "3"
            
            RequestService.shared.makeRequest(to: credentials.endpoint, with: params, using: authToken) { (localResult: Result<[BookBase], RequestError>) in
                switch localResult {
                case .failure(let error):
                    result = .failure(error)
                case .success(let books):
                    var newData = previousData
                    newData.append((credentials, Array(books.prefix(3))))
                    result = .success(newData)
                }
                semaphore.signal()
            }
            
            semaphore.wait()
            
            return result
        }
        
        func fetch(with appContext: AppContext) {
            guard !appContext.isPreview else {
                sections = [
                    (BookBase.new, BookBase.getItems(amount: 3)),
                    (BookBase.recommended, BookBase.getItems(amount: 3)),
                    (BookBase.rate, BookBase.getItems(amount: 3))
                ]
                return
            }
            guard viewState != .loading else { return }
            guard let authToken = appContext.credentials?.token else {
                sections = []
                viewState = .error("Not Logged In")
                return
            }
            
            viewState = .loading
            
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                var result: Result<[(RemoteDataCredentials, [BookBase])], RequestError> = .success([])
                for section in BookBase.home.sections {
                    result = result.flatMap { self?.loadBooks(section, with: authToken, previousData: $0) ?? .success([]) }
                }
                
                DispatchQueue.main.async { [weak self] in
                    switch result {
                    case .failure(let error):
                        self?.viewState = .error(error.description)
                    case .success(let books):
                        self?.sections = books
                        self?.viewState = .none
                    }
                }
            }
        }
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
