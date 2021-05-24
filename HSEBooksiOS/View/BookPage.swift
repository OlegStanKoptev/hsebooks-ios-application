//
//  BookPage.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 04.05.2021.
//

import SwiftUI

struct BookPage: View {
    @Binding var bookBase: BookBase
    @Binding var rating: Double
    @State var requestPresented = false
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @ObservedObject var appContext = AppContext.shared
    @State private var viewState: ViewState = .none
    @State private var bottomViewSelected = BottomViewSelection.description
    
    private var title: String { bookBase.title }
    private var author: String { bookBase.author }
    private var photoId: Int? { bookBase.photoId }
    private var year: Int { bookBase.publishYear }
    private var language: String { bookBase.language.rawValue }
    private var pages: Int { bookBase.numberOfPages }
    
    private var genres: String {
        let genresObjects = appContext.genres
        let genresStrings = bookBase.genreIds.map { id in
            genresObjects.first { genre in
                genre.id == id
            }?.name ?? "nil"
        }
        
        return genresStrings.isEmpty ? "No genres presented" : "Genre: \(genresStrings.joined(separator: ", "))"
    }
    
    private var description: String {
        bookBase.description ?? "No description available"
    }
    
    private func toggleWishlist() {
        appContext.toggleWishlist(of: bookBase, viewState: $viewState) { isToAdd in
            guard let user = appContext.credentials?.user else { return }
            if isToAdd {
                bookBase.wishersIds.append(user.id)
                appContext.credentials?.user.wishListIds.append(bookBase.id)
            } else {
                bookBase.wishersIds.removeAll(where: {$0 == user.id})
                appContext.credentials?.user.wishListIds.removeAll(where: {$0 == bookBase.id})
            }
        }
    }
    
    private func rateBook(stars: Int) {
        appContext.rateBook(bookBase, viewState: $viewState, stars: stars) { newRating in
            rating = newRating
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack {
                    VStack {
                        HStack(alignment: .top, spacing: 20) {
                            HStack(spacing: 18) {
                                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                                    Image(systemName: "arrow.left")
                                        .frame(width: UIFont.preferredFont(forTextStyle: .body).pointSize + 3)
                                }
                                Image(systemName: "heart")
                                    .frame(width: UIFont.preferredFont(forTextStyle: .body).pointSize + 3)
                                    .foregroundColor(.clear)
                            }
                            
                            BookCover(id: photoId, type: .bookBasePhoto)
                                .frame(height: 225)
//                                .border(Color.black)
                            
                            HStack(spacing: 18) {
//                                Image(systemName: "heart")
//                                .frame(width: UIFont.preferredFont(forTextStyle: .body).pointSize + 3)
//                                .foregroundColor(.clear)
                                
                                if appContext.credentials != nil {
                                    Button(action: { toggleWishlist() }) {
                                        Image(systemName: (appContext.isWished(bookBase) ? "heart.fill" : "heart"))
                                            .frame(width: UIFont.preferredFont(forTextStyle: .body).pointSize + 3)
                                    }
                                    
                                    Menu {
                                        ForEach(1..<6) { number in
                                            Button(action: { rateBook(stars: number) }) {
//                                                Label("\(number)", systemImage: "star")
                                                Text(String(number))
                                            }
                                        }
                                    } label: {
                                        Image(systemName: "star")
                                            .frame(width: UIFont.preferredFont(forTextStyle: .body).pointSize + 3)
                                    }
                                } else {
//                                Button(action: {}) {
//                                    Image(systemName: "square.and.arrow.up")
//                                        .frame(width: UIFont.preferredFont(forTextStyle: .body).pointSize + 3)
//                                }
//                                .disabled(true)
                                    
                                    Image(systemName: "heart")
                                        .frame(width: UIFont.preferredFont(forTextStyle: .body).pointSize + 3)
                                        .foregroundColor(.clear)
                                    
                                    Button(action: { toggleWishlist() }) {
                                        Image(systemName: (appContext.isWished(bookBase) ? "heart.fill" : "heart"))
                                            .frame(width: UIFont.preferredFont(forTextStyle: .body).pointSize + 3)
                                    }
                                }
                            }
                        }
                        .font(.system(size: UIFont.preferredFont(forTextStyle: .body).pointSize + 3))
                        .padding([.top, .horizontal])
                        
                        Text(title)
                            .font(.system(size: 20))
                            .lineLimit(2)
                        Text(author)
                            .font(.system(size: 16))
                            .foregroundColor(Color(.systemGray4))
                            .lineLimit(2)
                        
                        HStack {
                            RatingView(value: rating)
                            Text(rating.asStringWithOneDigit)
                                .foregroundColor(Color(.systemGray4))
                        }
                        
                        HStack {
                            HStack {
                                Spacer()
                                Text("\(bookBase.bookIds.count) available")
                                Spacer()
                            }
                            
                            Button(action: { requestPresented = true }) {
                                HStack {
                                    Spacer()
                                    Text("Request")
                                    Spacer()
                                }
                                .padding(.vertical, 8)
                                .background(
                                    Color.accentColor
                                        .cornerRadius(8.0)
                                )
                            }
                            .disabled(bookBase.bookIds.isEmpty)
                        }
                        .background(Color.white.opacity(0.25))
                        .padding(.top, 8)
                    }
                }
                .padding(.bottom, 12)
                
//                Picker(selection: $bottomViewSelected, label: Text("Picker")) {
//                    ForEach(BottomViewSelection.allCases) { `case` in
//                        Text(`case`.rawValue.capitalized).tag(`case`)
//                    }
//                }
//                .pickerStyle(SegmentedPickerStyle())
//                .padding(8)
            }
            .background(
                Color.tertiaryColor
                    .edgesIgnoringSafeArea(.top)
            )
            .foregroundColor(.white)
            
                switch bottomViewSelected {
                case .description:
                    VStack(spacing: 0) {
                        HStack {
                            Text(genres)
                            Spacer(minLength: 0)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(
                            Color.white
                                .shadow(color: .gray.opacity(0.5), radius: 2, y: 6)
                        )
                            
                        ScrollView(.vertical) {
                            VStack(spacing: 4) {
                                HStack {
                                    Text(description)
                                    Spacer(minLength: 0)
                                }
                                .padding(.horizontal)
                                .padding(.top, 12)
                                
                                HStack {
                                    Text(String(year)) +
                                        Text(" - ") +
                                    Text(language) +
                                        Text(" - ") +
                                    Text("\(pages) page\(pages != 1 ? "s" : "")")
                                    
                                    Spacer(minLength: 0)
                                }
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.horizontal)
                                .padding(.bottom, 12)
                            }
                        }
                    }
                case .reviews:
                    Text("Reviews")
                }
        }
        .disabled(viewState == .loading)
        .overlay(StatusOverlay(viewState: $viewState))
        .sheet(isPresented: $requestPresented) {
            NavigationView {
                RequestPage(bookBase: bookBase, presented: $requestPresented)
            }
        }
        .navigationBarHidden(true)
    }
}

extension BookPage {
    enum BottomViewSelection: String, CaseIterable, Identifiable {
        case description
        case reviews
        
        var id: String { self.rawValue }
    }
}

extension BookPage {
    struct RequestPage: View {
        @ObservedObject var appContext = AppContext.shared
        let bookBase: BookBase
        @Binding var presented: Bool
        @StateObject var viewModel = ViewModel()
        
        func fetch() {
            viewModel.fetch(of: bookBase, with: appContext)
        }
        
        func isOwnedByCurrentUser(_ book: Book) -> Bool {
            return book.ownerId == appContext.credentials?.user.id
        }
        
        func bookTownName(_ book: Book) -> String {
            appContext.towns.first(where: {$0.id == book.townId})?.name ?? "nil"
        }
        
        func bookQualityName(_ book: Book) -> String {
            appContext.quality.first(where: {$0.id == book.exteriorQualityId})?.name ?? "nil"
        }
        
        var body: some View {
            ScrollView(.vertical) {
                ForEach(viewModel.books, id: \.book.id) { row in
                    Group {
                        if isOwnedByCurrentUser(row.book) {
                            BookListRow(
                                title: "\(row.user.name) (it's your offer!)",
                                author: bookTownName(row.book),
                                photoId: row.book.photoId,
                                coverType: .bookPhoto,
                                thirdLine: Text("Quality: \(bookQualityName(row.book))"),
                                fourthLine: Text(row.book.creationDate.asDate))
                        } else {
                            NavigationLink(destination: BookPage.RequestForm(presentingForm: $presented, book: row.book, bookBase: bookBase, user: row.user)) {
                                BookListRow(title: row.user.name,
                                            author: bookTownName(row.book),
                                            photoId: row.book.photoId,
                                            coverType: .bookPhoto,
                                            thirdLine: Text("Quality: \(bookQualityName(row.book))"),
                                            fourthLine: Text(row.book.creationDate.asDate))
                            }
                        }
                             
                    }
                }
            }
            .overlay(StatusOverlay(viewState: $viewModel.viewState))
            .onAppear { fetch() }
            .navigationTitle("Offers")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: { presented = false })
                }
            }
        }
    }
}

extension BookPage.RequestPage {
    class ViewModel: ObservableObject {
        @Published var books: [(book: Book, user: User)] = []
        @Published var viewState: ViewState = .none
        
        func fetch(of bookBase: BookBase, with appContext: AppContext) {
            guard !appContext.isPreview else {
                books = [(book: Book.getItems(amount: 1).first!, user: User.getItems(amount: 1).first!)]
                return
            }
            guard viewState != .loading else { return }
            guard let token = appContext.credentials?.token else {
                books = []
                viewState = .error("Not Logged In")
                return
            }
            
            viewState = .loading
            
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                let semaphore = DispatchSemaphore(value: 0)
                
                var tempBooks = [Book]()
                let booksParams = ["ids": bookBase.bookIds.map{String($0)}.joined(separator: ",")]
                RequestService.shared.makeRequest(to: Book.book.endpoint, with: booksParams, using: token) { [weak self] (result: Result<[Book], RequestError>) in
                    switch result {
                    case .failure(let error):
                        self?.viewState = .error(error.description)
                    case .success(let resultBooks):
                        tempBooks = resultBooks
                    }
                    semaphore.signal()
                }
                semaphore.wait()
                
                var tempUsers = [User]()
                let usersParams = ["ids": tempBooks.map{String($0.ownerId)}.joined(separator: ",")]
                RequestService.shared.makeRequest(to: User.user.endpoint, with: usersParams, using: token) { [weak self] (result: Result<[User], RequestError>) in
                    switch result {
                    case .failure(let error):
                        self?.viewState = .error(error.description)
                    case .success(let resultUsers):
                        tempUsers = resultUsers
                    }
                    semaphore.signal()
                }
                semaphore.wait()
                
                guard self?.viewState == .loading else { return }
                
                var result = [(book: Book, user: User)]()
                for i in 0..<bookBase.bookIds.count {
                    result.append((book: tempBooks[i], user: tempUsers[i]))
                }
                
                DispatchQueue.main.async { [weak self] in
                    self?.books = result
                    self?.viewState = .none
                }
            }
        }
    }
}

extension BookPage {
    struct RequestForm: View {
        @ObservedObject var appContext = AppContext.shared
        @StateObject var viewModel = ViewModel()
        @Binding var presentingForm: Bool
        @State var message: String = ""
        
        let book: Book
        let bookBase: BookBase
        let user: User
        
        var town: String {
            String(appContext.towns.first(where: { $0.id == book.townId })!.name)
        }
        
        func sendRequest() {
            viewModel.request(a: book, from: user, with: message, using: appContext, presenting: $presentingForm)
        }
        
        var body: some View {
            VStack(spacing: 0) {
                HStack {
                    BookCover(id: book.photoId, type: .bookPhoto)
                        .frame(height: 120)
                    
                    VStack(alignment: .leading) {
                        Text(bookBase.title)
                        Text(bookBase.author)
                    }
                    Spacer()
                    Spacer()
                }
                .padding(.vertical, 8)
                .padding(.horizontal)
                .background(
                    Color.white
                        .shadow(radius: 10)
                )
                
                ScrollView(.vertical) {
                    VStack(spacing: 8) {
                        Label(
                            title: {
                                HStack {
                                    Text(user.name)
                                    Spacer()
                                }
                                .padding(6)
                                .background(
                                    Color(.systemGray6)
                                        .cornerRadius(8)
                                        .shadow(color: .gray.opacity(0.5), radius: 1, y: 2)
                                )
                            },
                            icon: {
                                Image(systemName: "person.circle.fill")
                                    .font(.system(size: 20))
                                    .frame(width: UIFont.preferredFont(forTextStyle: .body).pointSize + 6)
                                    .foregroundColor(.tertiaryColor)
                            }
                        )
                        
                        Label(
                            title: {
                                HStack {
                                    Text(town)
                                    Spacer()
                                }
                                .padding(6)
                                .background(
                                    Color(.systemGray6)
                                        .cornerRadius(8)
                                        .shadow(color: .gray.opacity(0.5), radius: 1, y: 2)
                                )
                            },
                            icon: {
                                Image(systemName: "mappin")
                                    .font(.system(size: 20))
                                    .frame(width: UIFont.preferredFont(forTextStyle: .body).pointSize + 6)
                                    .foregroundColor(.accentColor)
                            }
                        )
                    }
                    .padding()
                
                    VStack(spacing: 4) {
                        HStack {
                            Text("Please leave a message for the owner:")
                            Spacer()
                        }
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 4)
                        
                        TextEditor(text: $message)
                            .border(Color(.systemGray4), width: 4)
                            .frame(minHeight: 120)
                            .disabled(viewModel.viewState == .loading)
                    }
                    .padding(.horizontal, 8)
                    .padding(.bottom, 24)
                }
                
                Button("Send a request") { sendRequest() }
                    .buttonStyle(FilledRoundedButtonStyle(verticalPadding: 12))
                    .padding(.horizontal)
                    .disabled(viewModel.viewState == .loading)
                
                Spacer()
            }
            .overlay(StatusOverlay(viewState: $viewModel.viewState))
            .navigationTitle("Request Form")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

extension BookPage.RequestForm {
    class ViewModel: ObservableObject {
        @Published var viewState: ViewState = .none
        
        func request(a book: Book, from user: User, with message: String, using appContext: AppContext, presenting: Binding<Bool>) {
            guard !appContext.isPreview else { return }
            guard let token = appContext.credentials?.token else { return }
            
            viewState = .loading
            
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                let semaphore = DispatchSemaphore(value: 0)
                
                var request: BookExchangeRequest?
                let body = [
                    "userFromId": String(user.id),
                    "exchangingBookId": String(book.id)
                ]
                
                RequestService.shared.makePostRequest(to: BookExchangeRequest.request.endpoint, with: token, body: body) { [weak self] (result: Result<BookExchangeRequest, RequestError>) in
                    switch result {
                    case .failure(let error):
                        self?.viewState = .error(error.description)
                    case .success(let requestRes):
                        request = requestRes
                    }
                    semaphore.signal()
                }
                semaphore.wait()
                
                guard !message.isEmpty else {
                    DispatchQueue.main.async { [weak self] in
                        self?.viewState = .none
                        presenting.wrappedValue = false
                    }
                    return
                }
                
                guard let request = request, self?.viewState == .loading else {
                    DispatchQueue.main.async {
                        presenting.wrappedValue = false
                    }
                    return
                }
                
                let messageBody = [
                    "body": "\(message)",
                    "dialogId": "\(request.dialogId)"
                ]
                
                print(messageBody)
                RequestService.shared.makePostRequest(to: Message.all.endpoint, with: token, body: messageBody) { [weak self] (result: Result<Message, RequestError>) in
                    switch result {
                    case .failure(let error):
                        self?.viewState = .error(error.description)
                    case .success(_):
                        self?.viewState = .none
                        presenting.wrappedValue = false
                    }
                }
            }
        }
    }
}

struct BookPage_Previews: PreviewProvider {
    static var previews: some View {
        BookPage(bookBase: .constant(BookBase.getItems(amount: 1).first!), rating: .constant(5.0), appContext: .preview)
    }
}
