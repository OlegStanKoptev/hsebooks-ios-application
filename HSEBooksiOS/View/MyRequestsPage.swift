//
//  MyRequestsPage.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 06.05.2021.
//

import SwiftUI

struct MyRequestsPage: View {
    @Binding var selectedTab: Int
    @ObservedObject var appContext = AppContext.shared
    
    enum Page: String, CaseIterable {
        case incoming = "Incoming"
        case outcoming = "Outcoming"
    }
    
    @State var currentPage: Page = .outcoming
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Picker(selection: $currentPage, label: EmptyView()) {
                    Text("Incoming Requests")
                        .tag(Page.incoming)
                    Text("My Requests")
                        .tag(Page.outcoming)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 8)
                .padding(.bottom, 8)
                .background(Color.tertiaryColor)
                
                Group {
                    switch currentPage {
                    case .incoming:
                        IncomingRequests(selectedTab: $selectedTab, currentPage: $currentPage)
                    case .outcoming:
                        OutcomingRequests(selectedTab: $selectedTab, currentPage: $currentPage)
                    }
                }
                
                Spacer(minLength: 0)
            }
            .navigationTitle("My Requests")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

extension MyRequestsPage {
    struct IncomingRequests: View {
        @Binding var selectedTab: Int
        @Binding var currentPage: Page
        @ObservedObject var appContext = AppContext.shared
        @StateObject private var viewModel = ViewModel()
        
        @State private var presentConfirm: Bool = false
        @State private var requestMethod: RequestMethod? = nil
        
        enum RequestMethod {
            case accept(BookExchangeRequest)
            case decline(BookExchangeRequest)
        }
        
        private func fetch() {
            viewModel.fetch(page: .incoming, with: appContext)
        }
        
        var body: some View {
            VStack {
                ScrollView(.vertical) {
                    if viewModel.requests.isEmpty {
                        Text("List is empty!")
                            .padding()
                            .foregroundColor(.secondary)
                    } else {
                        VStack(spacing: 0) {
                            ForEach(viewModel.requests, id: \.0.id) { (request, book, bookBase, town, user) in
                                BookListIncomingRequestRow(
                                    title: bookBase.title,
                                    author: bookBase.author,
                                    photoId: book.photoId,
                                    name: user.name,
                                    city: town.name,
                                    date: request.creationDate,
                                    status: request.status,
                                    destination: Chat(book: book, bookBase: bookBase, user: user, requestId: request.id),
                                    onAccept: {
                                        requestMethod = .accept(request)
                                        presentConfirm = true
                                    },
                                    onDecline: {
                                        requestMethod = .decline(request)
                                        presentConfirm = true
                                    }
                                )
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .disabled(viewModel.viewState == .loading)
            .overlay(StatusOverlay(viewState: $viewModel.viewState))
            .onAppear { fetch() }
            .onChange(of: currentPage, perform: { value in
                if value == .incoming {
                    fetch()
                }
            })
            .onChange(of: selectedTab) { value in
                if value == 3 {
                    fetch()
                }
            }
            .actionSheet(isPresented: $presentConfirm) {
                switch requestMethod {
                case .accept(let request):
                    return ActionSheet(
                        title: Text("Are you sure want to accept?"),
                        buttons: [
                            .default(Text("Accept"), action: {
                                viewModel.accept(request: request, with: appContext) {
                                    fetch()
                                }
                            }),
                            .cancel()
                        ]
                    )
                case .decline(let request):
                    return ActionSheet(
                        title: Text("Are you sure want to decline?"),
                        buttons: [
                            .default(Text("Decline"), action: {
                                viewModel.decline(request: request, with: appContext) {
                                    fetch()
                                }
                            }),
                            .cancel()
                        ]
                    )
                case .none:
                    return ActionSheet(
                        title: Text("Request is not chosen"),
                        buttons: [
                            .cancel()
                        ]
                    )
                }
                
            }
        }
    }
}

extension MyRequestsPage {
    struct OutcomingRequests: View {
        @Binding var selectedTab: Int
        @Binding var currentPage: Page
        @ObservedObject var appContext = AppContext.shared
        @StateObject private var viewModel = ViewModel()
        
        private func fetch() {
            viewModel.fetch(page: .outcoming, with: appContext)
        }
        
        var body: some View {
            VStack {
                ScrollView(.vertical) {
                    if viewModel.requests.isEmpty {
                        Text("List is empty!")
                            .padding()
                            .foregroundColor(.secondary)
                    } else {
                        VStack(spacing: 0) {
                            ForEach(viewModel.requests, id: \.0.id) { (request, book, bookBase, town, user) in
                                BookListOutcomingRequestRow(
                                    title: bookBase.title,
                                    author: bookBase.author,
                                    photoId: book.photoId,
                                    name: user.name,
                                    city: town.name,
                                    date: request.creationDate,
                                    status: request.status,
                                    destination: Chat(book: book, bookBase: bookBase, user: user, requestId: request.id)
                                )
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .disabled(viewModel.viewState == .loading)
            .onChange(of: currentPage, perform: { value in
                if value == .outcoming {
                    fetch()
                }
            })
            .onChange(of: selectedTab) { value in
                if value == 3 {
                    fetch()
                }
            }
            .onAppear { fetch() }
            .overlay(StatusOverlay(viewState: $viewModel.viewState))
        }
    }
}


extension MyRequestsPage {
    class ViewModel: ObservableObject {
        @Published var requests: [(BookExchangeRequest, Book, BookBase, Town, User)] = []
        @Published var viewState: ViewState = .none
        
        private func fetch<T: Decodable>(ids: [Int], to credentials: RemoteDataCredentials, with token: String) -> [T] {
            var items = [T]()
            var params = credentials.params
            params["ids"] = ids.map { String($0) }.joined(separator: ",")
            let semaphore = DispatchSemaphore(value: 0)
            RequestService.shared.makeRequest(to: credentials.endpoint, with: params, using: token) { [weak self] (result: Result<[T], RequestError>) in
                switch result {
                case .failure(let error):
                    self?.viewState = .error(error.description)
                case .success(let resultItems):
                    items = resultItems
                }
                semaphore.signal()
            }
            semaphore.wait()
            return items
        }
        
        func fetch(page: Page, with context: AppContext) {
            guard !context.isPreview else {
                requests = [(
                    BookExchangeRequest.getItems(amount: 1)[0],
                    Book.getItems(amount: 1)[0],
                    BookBase.getItems(amount: 1)[0],
                    Town.getItems(amount: 1)[0],
                    User.getItems(amount: 1)[0]
                )]
                return
            }
            guard viewState != .loading else { return }
            
            guard let token = context.credentials?.token else {
                requests = []
                viewState = .error("Not Logged In")
                return
            }
//            requests = []
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
                guard let user = context.credentials?.user, self?.viewState == .loading else { return }
                
                let list = page == .incoming ? user.outcomingBookExchangeRequestIds : user.incomingBookExchangeRequestIds
                
                let tempRequests: [BookExchangeRequest] =
                    self?.fetch(ids: list, to: BookExchangeRequest.request, with: token) ?? []

                let tempBooks: [Book] =
                    self?.fetch(ids: tempRequests.map{$0.exchangingBookId}, to: Book.book, with: token) ?? []

                let tempBookBases: [BookBase] =
                    self?.fetch(ids: tempBooks.map{$0.baseId}, to: BookBase.book, with: token) ?? []

                let tempUsers: [User] =
                    self?.fetch(ids: tempRequests.map{ page == .incoming ? $0.userToId : $0.userFromId}, to: User.user, with: token) ?? []

                guard self?.viewState == .loading else { return }

                var result = [(BookExchangeRequest, Book, BookBase, Town, User)]()
                
                if tempRequests.count == tempBooks.count,
                   tempBooks.count == tempBookBases.count,
                   tempBookBases.count == tempUsers.count {
                    for i in 0..<tempRequests.count {
                        result.append((tempRequests[i], tempBooks[i], tempBookBases[i], context.towns.first { $0.id == tempBooks[i].townId } ?? Town(id: 1, creationDate: "", name: "nil", bookIds: []), tempUsers[i]))
                    }
                } else {
                    result = []
                }
                

                DispatchQueue.main.async { [weak self] in
                    self?.requests = result
                    self?.viewState = .none
                }
            }
        }
        
        func accept(request: BookExchangeRequest, with context: AppContext, handler: @escaping () -> Void = {}) {
            guard !context.isPreview else { return }
            guard let token = context.credentials?.token else {
                viewState = .error("Not Logged In")
                return
            }
            viewState = .loading
            RequestService.shared.makePatchRequest(to: "\(BookExchangeRequest.request.endpoint)/\(request.id)/accept", with: token) { [weak self] (result: Result<BookExchangeRequest, RequestError>) in
                switch result {
                case .failure(let error):
                    self?.viewState = .error(error.description)
                case .success(_):
                    self?.viewState = .none
                    handler()
                }
            }
        }
        
        func decline(request: BookExchangeRequest, with context: AppContext, handler: @escaping () -> Void = {}) {
            guard !context.isPreview else { return }
            guard let token = context.credentials?.token else {
                viewState = .error("Not Logged In")
                return
            }
            viewState = .loading
            RequestService.shared.makePatchRequest(to: "\(BookExchangeRequest.request.endpoint)/\(request.id)/reject", with: token) { [weak self] (result: Result<BookExchangeRequest, RequestError>) in
                switch result {
                case .failure(let error):
                    self?.viewState = .error(error.description)
                case .success(_):
                    self?.viewState = .none
                    handler()
                }
            }
        }
    }
}

struct MyRequestsPage_Previews: PreviewProvider {
    static var previews: some View {
        MyRequestsPage(selectedTab: .constant(1), appContext: .preview)
    }
}
