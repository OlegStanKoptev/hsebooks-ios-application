//
//  MyBooksPage.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 06.05.2021.
//

import SwiftUI
import Combine

struct MyBooksPage: View {
    @Binding var selectedTab: Int
    @ObservedObject var appContext = AppContext.shared
    @StateObject private var viewModel = ViewModel()
    @State private var newBookViewPresented: Bool = false
    
    func fetch() {
        viewModel.fetch(with: appContext)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HeaderWithSearchAndTitle(title: "My Books", hideBackButton: true)
                
                ZStack {
                    ScrollView(.vertical) {
                        VStack(spacing: 0) {
                            ForEach(viewModel.books, id: \.book.id) { (book, base) in
                                Row(book: book, bookBase: base) {
                                    viewModel.changeAvailability(of: book, with: appContext)
                                }
                            }
                        }
                    }
                    
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            
                            Button(action: { newBookViewPresented = true }) {
                                Image(systemName: "plus")
                                    .font(.system(size: 30))
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(
                                        Circle()
                                            .fill(Color.orange)
                                    )
                            }
                        }
                    }
                    .padding()
                }
                .disabled(viewModel.viewState == .loading)
            }
            .overlay(StatusOverlay(viewState: $viewModel.viewState))
            .navigationTitle("My Books")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
            .onAppear { fetch() }
            .onChange(of: selectedTab) { value in
                if value == 2 {
                    fetch()
                }
            }
            .sheet(isPresented: $newBookViewPresented, onDismiss: { fetch() }) {
                NewBookMenu(presented: $newBookViewPresented)
            }
        }
    }
}

extension MyBooksPage {
    struct Row: View {
        let book: Book
        let bookBase: BookBase
        var onChangeAvailability: (() -> Void)?
        
        @ObservedObject var appContext = AppContext.shared
        @State private var showingActionSheet: Bool = false
        
        private var quality: String {
            appContext.quality.first { $0.id == book.exteriorQualityId }?.name ?? "nil"
        }
        
        private var availabilityChange: String {
            book.publicityStatus == .private ? Book.PublicityStatus.public.rawValue : Book.PublicityStatus.private.rawValue
        }
        
        var body: some View {
            BookListRow(
                title: bookBase.title,
                author: bookBase.author,
                photoId: book.photoId,
                coverType: .bookPhoto,
                thirdLine:
                    Text("Exterior Quality: \(quality)"),
                fourthLine:
                    Text("Availability: \(book.publicityStatus.rawValue)")
            )
            .overlay(
                HStack {
                    Spacer()
                    
                    VStack {
                        Menu {
                            Button("Change availability", action: {
                                showingActionSheet = true
                            })
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
            .actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(
                    title: Text("Change availability of the book"),
                    buttons: [
                        .default(Text("Set it to \(availabilityChange)"), action: {
                            showingActionSheet = false
                            onChangeAvailability?()
                        }),
                        .cancel()
                    ]
                )
            }
        }
    }
}

extension MyBooksPage {
    class ViewModel: ObservableObject {
        @Published var books: [(book: Book, base: BookBase)] = []
        @Published var viewState: ViewState = .none
        
        func changeAvailability(of book: Book, with appContext: AppContext) {
            guard !appContext.isPreview, viewState != .loading else { return }
            guard let token = appContext.credentials?.token else {
                books = []
                viewState = .error("Not Logged In")
                return
            }
            
            viewState = .loading
            var mutableBook = book
            mutableBook.publicityStatus = book.publicityStatus == .private ? .public : .private
            
            RequestService.shared.makePutRequest(to: "\(Book.book.endpoint)/\(book.id)", with: token, body: mutableBook) { [weak self] (result: Result<Book, RequestError>) in
                switch result {
                case .failure(let error):
                    self?.viewState = .error(error.description)
                case .success(let data):
                    if let index = self?.books.firstIndex(where: { $0.book.id == data.id }),
                       let base = self?.books[index].base {
                        self?.books[index] = (book: data, base: base)
                    } else {
                        self?.fetch(with: appContext)
                    }
                    self?.viewState = .none
                }
            }
        }
        
        func fetch(with appContext: AppContext) {
            guard !appContext.isPreview else {
                books = [(book: Book.getItems(amount: 1).first!, base: BookBase.getItems(amount: 1).first!)]
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
                
                appContext.updateUserInfo { [weak self] result in
                    switch result {
                    case .failure(let error):
                        self?.viewState = .error(error.description)
                    case .success(_): break
                    }
                    semaphore.signal()
                }
                
                semaphore.wait()
                
                guard self?.viewState == .loading, let user = appContext.credentials?.user else {
                    DispatchQueue.main.async { [weak self] in
                        self?.books = []
                    }
                    return
                }
                
                var realBooks: [Book] = []
                let params = ["ids": user.exchangeListIds.map {String($0)}.joined(separator: ",")]
                
                RequestService.shared.makeRequest(to: Book.book.endpoint, with: params, using: token) { [weak self] (result: Result<[Book], RequestError>) in
                    switch result {
                    case .failure(let error):
                        self?.viewState = .error(error.description)
                    case .success(let books):
                        realBooks = books
                    }
                    semaphore.signal()
                }
                
                semaphore.wait()
                
                guard self?.viewState == .loading else {
                    DispatchQueue.main.async { [weak self] in
                        self?.books = []
                    }
                    return
                }
                
                let bookBaseParams = ["ids": realBooks.map { String($0.baseId) }.joined(separator: ",")]
                
                var bookBases: [BookBase] = []
                RequestService.shared.makeRequest(to: BookBase.book.endpoint, with: bookBaseParams, using: token) { [weak self] (result: Result<[BookBase], RequestError>) in
                    switch result {
                    case .failure(let error):
                        self?.viewState = .error(error.description)
                    case .success(let books):
                        bookBases = books
                    }
                    semaphore.signal()
                }
                
                semaphore.wait()
                
                guard self?.viewState == .loading else {
                    DispatchQueue.main.async { [weak self] in
                        self?.books = []
                    }
                    return
                }
                
                DispatchQueue.main.async { [weak self] in
                    self?.books = []
                    for i in 0..<realBooks.count {
                        self?.books.append((book: realBooks[i], base: bookBases[i]))
                    }
                    self?.viewState = .none
                }
            }
        }
    }
}

extension MyBooksPage {
    struct NewBookMenu: View {
        @Binding var presented: Bool
        
        var body: some View {
            NavigationView {
                Group {
                    VStack(spacing: 0) {
                        NavigationLink(destination: NewBook(presented: $presented)) {
                            HStack {
                                Spacer()
                                Text("Choose the existing book base")
                                Spacer()
                            }
                        }
                        .buttonStyle(FilledRoundedButtonStyle(verticalPadding: 12))
                        .padding()

                        Text("Or if you cannot find one ")

                        NavigationLink(destination: NewBookBase(presented: $presented)) {
                            HStack {
                                Spacer()
                                Text("Create a new book base")
                                Spacer()
                            }
                        }
                        .buttonStyle(FilledRoundedButtonStyle(verticalPadding: 12))
                        .padding()

                        Spacer()
                    }
                    .padding(.vertical)
                    .background(
                        Color(.systemGroupedBackground)
                            .edgesIgnoringSafeArea(.all)
                    )
                }
                .navigationTitle("New Book")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel", action: { presented = false })
                    }
                }
            }
        }
    }
}

extension MyBooksPage.NewBookMenu {
    struct NewBook: View {
        @Binding var presented: Bool
        
        @ObservedObject var appContext = AppContext.shared
        @StateObject private var viewModel = ViewModel()
        @State private var bookSelectorPresented: Bool = false
        @State private var bookBase: BookBase?
        @State private var quality: ExteriorQuality?
        @State private var town: Town?
        @State private var imageSelectorPresented = false
        @State private var selectedImage: UIImage?
        
        private func select(_ quality: ExteriorQuality) {
            self.quality = quality
        }
        
        private func select(_ town: Town) {
            self.town = town
        }
        
        private func addBook() {
            viewModel.addBook(bookBase: bookBase, quality: quality, town: town, image: selectedImage, context: appContext, presented: $presented)
        }
        
        private func setDefaultTown() {
            if let user = appContext.credentials?.user,
               let cachedTown = appContext.towns.first(where: {$0.id == user.townId}) {
                town = cachedTown
            }
        }
        
        var body: some View {
            VStack {
                if let bookBase = bookBase {
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
                    )
                    
                    Form {
                        Menu {
                            ForEach(appContext.quality) { quality in
                                Button(quality.name, action: {
                                    select(quality)
                                })
                            }
                        } label: {
                            HStack {
                                Text("Quality")
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                if let quality = quality {
                                    Text(quality.name)
                                        .foregroundColor(.secondary)
                                }
                                
                                Image(systemName: "chevron.forward")
                                    .font(.system(size: 13.5, weight: .semibold, design: .default))
                                    .foregroundColor(.init(.systemGray3))
                            }
                        }
                        
                        Menu {
                            ForEach(appContext.towns) { town in
                                Button(town.name, action: {
                                    select(town)
                                })
                            }
                        } label: {
                            HStack {
                                Text("Town")
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                if let town = town {
                                    Text(town.name)
                                        .foregroundColor(.secondary)
                                }
                                
                                Image(systemName: "chevron.forward")
                                    .font(.system(size: 13.5, weight: .semibold, design: .default))
                                    .foregroundColor(.init(.systemGray3))
                            }
                            .onAppear {
                                setDefaultTown()
                            }
                        }
                        
                        VStack {
                            Button(action: {
                                imageSelectorPresented = true
                            }) {
                                HStack {
                                    Text("Image")
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.forward")
                                        .font(.system(size: 13.5, weight: .semibold, design: .default))
                                        .foregroundColor(.init(.systemGray3))
                                }
                            }
                            
                            if let selectedImage = selectedImage {
                                Image(uiImage: selectedImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxHeight: UIScreen.main.bounds.height * 0.5)
                            }
                        }
                    }
                    .overlay(
                        VStack {
                            Spacer()
                            
                            HStack {
                                Spacer(minLength: 0)
                                Button(action: { addBook() }) {
                                    Text("Add to my collection")
                                }
                                .buttonStyle(FilledRoundedButtonStyle(verticalPadding: 12))
                                Spacer(minLength: 0)
                            }
                            .padding()
                        }
                    )
                }
            }
            .background(
                Color(.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)
            )
            .disabled(viewModel.viewState == .loading)
            .overlay(StatusOverlay(viewState: $viewModel.viewState))
            .sheet(isPresented: $imageSelectorPresented) {
                PhotoPicker(isPresented: $imageSelectorPresented) { image in
                    selectedImage = image
                }
            }
            .sheet(isPresented: $bookSelectorPresented, onDismiss: {
                presented = bookBase != nil
            }) {
                SearchPage() {
                    bookSelectorPresented = false
                } onSelect: {
                    self.bookBase = $0
                    bookSelectorPresented = false
                }
            }
            .onAppear {
                bookSelectorPresented = true
            }
            .navigationTitle("Existing Book")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

extension MyBooksPage.NewBookMenu.NewBook {
    class ViewModel: ObservableObject {
        @Published var viewState: ViewState = .none
        
        func addBook(bookBase: BookBase?, quality: ExteriorQuality?, town: Town?, image: UIImage?, context: AppContext, presented: Binding<Bool>) {
            guard !context.isPreview, viewState != .loading else { return }
            guard let token = context.credentials?.token,
                  let user = context.credentials?.user,
                  let bookBase = bookBase,
                  let quality = quality,
                  let town = town,
                  let image = image else {
                viewState = .error("All fields are mandatory!")
                return
            }
            
            viewState = .loading
            
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                guard let imageData = image.jpegData(compressionQuality: 0.3) else {
                    DispatchQueue.main.async { [weak self] in
                        self?.viewState = .error("Problem occurred while processing the image!")
                    }
                    return
                }
                
                let imageString = imageData.base64EncodedString()
                let semaphore = DispatchSemaphore(value: 0)
                var book: Book?
                let bookBody = [
                    "exteriorQualityId": "\(quality.id)",
                    "ownerId": "\(user.id)",
                    "baseId": "\(bookBase.id)",
                    "townId": "\(town.id)"
                ]
                
                RequestService.shared.makePostRequest(to: Book.book.endpoint, with: token, body: bookBody) { [weak self] (result: Result<Book, RequestError>) in
                    switch result {
                    case .failure(let error):
                        self?.viewState = .error(error.description)
                    case .success(let data):
                        book = data
                    }
                    semaphore.signal()
                }
                
                semaphore.wait()
                
                guard let book = book else { return }
                
                var imageRes: BookPhoto?
                let imageBody = [
                    "bookId": "\(book.id)",
                    "image": "\(imageString)"
                ]
                
                RequestService.shared.makePostRequest(to: BookPhoto.all.endpoint, with: token, body: imageBody) { [weak self] (result: Result<BookPhoto, RequestError>) in
                    switch result {
                    case .failure(let error):
                        self?.viewState = .error(error.description)
                    case .success(let photo):
                        imageRes = photo
                    }
                    semaphore.signal()
                }
                semaphore.wait()
                guard let _ = imageRes else { return }
                
                DispatchQueue.main.async { [weak self] in
                    self?.viewState = .none
                    presented.wrappedValue = false
                }
            }
        }
    }
}

extension MyBooksPage.NewBookMenu {
    struct NewBookBase: View {
        @Binding var presented: Bool
        @ObservedObject var appContext = AppContext.shared
        @StateObject private var viewModel = ViewModel()
        @State private var title: String = ""
        @State private var author: String = ""
        @State private var language: Language?
        @State private var genresMenuPresented: Bool = false
        @State private var genres: [Genre] = []
        @State private var publishYear: String = ""
        @State private var pagesQuantity: String = ""
        @State private var description: String = ""
        private let descriptionPlaceholder = "Description"
        
        private func select(_ language: Language) {
            self.language = language
        }
        
        private func sendRequest() {
            viewModel.sendRequest(title: title, author: author, language: language, genres: genres, publishYear: publishYear, pagesQuantity: pagesQuantity, description: description, context: appContext, presented: $presented)
        }
        
        var body: some View {
            VStack(spacing: 0) {
                Form {
                    TextField("Title", text: $title)
                    TextField("Author", text: $author)
                    
                    Menu {
                        ForEach(Language.getItems(amount: 0)) { language in
                            Button(language.rawValue, action: {
                                select(language)
                            })
                        }
                    } label: {
                        HStack {
                            Text("Language")
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            if let language = language {
                                Text(language.rawValue)
                                    .foregroundColor(.secondary)
                            }
                            
                            Image(systemName: "chevron.forward")
                                .font(.system(size: 13.5, weight: .semibold, design: .default))
                                .foregroundColor(.init(.systemGray3))
                        }
                    }
                    
                    NavigationLink(
                        destination:
                            GenresSelection(
                                allGenres: appContext.genres,
                                selection: $genres
                            ),
                        isActive: $genresMenuPresented
                    ) {
                        HStack {
                            Text("Genres")
                                .foregroundColor(.primary)

                            Spacer()

                            if let genres = genres {
                                Text(genres.map{$0.name}.joined(separator: ", "))
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    TextField("Publish Year", text: $publishYear)
                        .keyboardType(.numberPad)
                        .onReceive(Just(publishYear)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                publishYear = filtered
                            }
                        }
                    
                    TextField("Pages Quantity", text: $pagesQuantity)
                        .keyboardType(.numberPad)
                        .onReceive(Just(pagesQuantity)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                pagesQuantity = filtered
                            }
                        }
                    
                    TextEditor(text: $description)
                        .background(
                            HStack {
                                Text(descriptionPlaceholder)
                                    .foregroundColor(.init(.systemGray3))
                                Spacer()
                            }
                            .padding(.horizontal, 5)
                            .padding(.bottom, 1)
                            .opacity(description.isEmpty ? 1 : 0)
                        )
                }
                
                HStack {
                    Spacer(minLength: 0)
                    Button(action: { sendRequest() }) {
                        Text("Send the request")
                    }
                    .buttonStyle(FilledRoundedButtonStyle(verticalPadding: 12))
                    Spacer(minLength: 0)
                }
                .padding()
            }
            .background(
                Color(.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)
            )
            .disabled(viewModel.viewState == .loading)
            .overlay(StatusOverlay(viewState: $viewModel.viewState))
            .navigationTitle("New Book")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

extension MyBooksPage.NewBookMenu.NewBookBase {
    struct GenresSelection: View {
        let allGenres: [Genre]
        @Binding var selection: [Genre]
        var body: some View {
            List(allGenres) { genre in
                Button(action: {
                    if let index = selection.firstIndex(of: genre) {
                        selection.remove(at: index)
                    } else {
                        selection.append(genre)
                    }
                }) {
                    HStack {
                        Text(genre.name)
                            .foregroundColor(.primary)
                        Spacer()
                        if selection.contains(genre) {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
            .navigationTitle("Genre Selection")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

extension MyBooksPage.NewBookMenu.NewBookBase {
    class ViewModel: ObservableObject {
        @Published var viewState: ViewState = .none
        
        func sendRequest(title: String, author: String, language: Language?, genres: [Genre], publishYear: String, pagesQuantity: String, description: String, context: AppContext, presented: Binding<Bool>) {
            guard !context.isPreview else {
                presented.wrappedValue = false
                return
            }
            guard viewState != .loading else { return }
            guard let token = context.credentials?.token,
                  !title.isEmpty,
                  !author.isEmpty,
                  let language = language,
                  !genres.isEmpty,
                  let publishYear = Int(publishYear),
                  let pagesQuantity = Int(pagesQuantity) else {
                viewState = .error("All fields are mandatory")
                return
            }
            
            viewState = .loading
            
            let body = BookBaseRequest.PostRequest(author: author, language: language, title: title, numberOfPages: pagesQuantity, genreIds: genres.map{$0.id}, publishYear: publishYear)
            
            RequestService.shared.makePostRequest(to: BookBase.request.endpoint, with: token, body: body) { [weak self] (result: Result<BookBaseRequest, RequestError>) in
                switch result {
                case .failure(let error):
                    self?.viewState = .error(error.description)
                case .success(_):
                    self?.viewState = .none
                    presented.wrappedValue = false
                }
            }
        }
    }
}

struct MyBooksPage_Previews: PreviewProvider {
    static var previews: some View {
        MyBooksPage(selectedTab: .constant(1), appContext: .preview)
    }
}
