//
//  BookList.swift
//  BookExchange
//
//  Created by Oleg Koptev on 21.01.2021.
//

import SwiftUI

struct BookList: View {
    // MARK: SwiftUI variables
    @State var searchText: String = ""
    @State var serverBooksLoading: Bool = false
    
    // MARK: Data variables
    var localBooks: [BookListItem] = [
        BookListItem(author: "Jack Canfield", title: "Chicken Soup", rating: 1.2, city: "Moscow", picture: Image("Book Cover")),
        BookListItem(author: "Other Author", title: "Popular book", rating: 3.7, city: "Moscow", picture: Image("Book Cover")),
        BookListItem(author: "Default Author", title: "Another Book", rating: 5.0, city: "Moscow", picture: Image("Book Cover"))
    ]
    
    @State var serverBooks: [BookListItem] = [BookListItem(author: "Default Author", title: "Another Book", rating: 5.0, city: "Moscow")]
    
    // MARK: Body
    var body: some View {
        VStack(spacing: 0) {
            BookListSelector()
            ZStack {
                BookListContent(localBooks: localBooks, serverBooks: $serverBooks, serverBooksLoading: $serverBooksLoading)
                LoadBooksButton(serverBooksLoading: $serverBooksLoading, serverBooks: $serverBooks)
            }
            Spacer(minLength: 0)
        }
        .accentColor(.blue)
        .toolbar {
            ToolbarItem(placement: .principal) {
                SearchBar(searchText: $searchText)
            }
        }
    }
}

struct BookList_Previews: PreviewProvider {
    static var previews: some View {
        BookList()
//            .wrapNavigationView()
    }
}

struct BookListSelector: View {
    @ObservedObject var viewRouter: BookListViewRouter = BookListViewRouter()
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 18) {
                Color.clear.frame(width: 0)
                ForEach(BookListPage.allCases, id: \.rawValue) { page in
                    Text(page.rawValue)
                        .foregroundColor(viewRouter.currentPage == page ? .orange : .white)
                        .onTapGesture {
                            viewRouter.currentPage = page
                        }
                }
                Spacer(minLength: 0)
            }
            .font(.system(size: 15))
            .textCase(.uppercase)
            .frame(height: 36)
            .foregroundColor(.white)
        }
        .background(Color("Accent"))
    }
}

struct BookListContent: View {
    var localBooks: [BookListItem]
    @Binding var serverBooks: [BookListItem]
    @Binding var serverBooksLoading: Bool
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(spacing: 8) {
                Ad()
                BookListSection(header: "Local books", books: localBooks)
                BookListLoadableSection(header: "Books from server", books: serverBooks, serverBooksLoading: $serverBooksLoading)
                Color.clear.frame(height: 100)
            }
        }
    }
}

struct LoadBooksButton: View {
    @Binding var serverBooksLoading: Bool
    @Binding var serverBooks: [BookListItem]
    
    func getBooksFromServer() {
        serverBooksLoading = true
        var request = URLRequest(url: URL(string: "https://books.infostrategic.com/bookBase/")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJPbGVnU3RhbiIsImV4cCI6MTYxMjExNjM4Nn0.O1na5zxn28IRpLr3mZjwBOaQXbS1iTFz1ref7psPPpqFHWB_3v5Zwr-vwTXYA-tiRf1X8far-hOn6tNCbXycvg", forHTTPHeaderField: "Authorization")

        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { (data, _, _) in
            guard let data = data else { return }
            let books = try? JSONDecoder().decode([BookBase].self, from: data)
            if let books = books {
                var newBooks: [BookListItem] = []
                for book in books {
                    newBooks.append(
                        BookListItem(author: book.author, title: book.title, rating: book.rating, city: book.language, pictureUrl: book.pictureUrl)
                    )
                }
                DispatchQueue.main.async {
                    serverBooks = newBooks
                }
            } else {
                DispatchQueue.main.async {
                    serverBooks = []
                }
            }
            serverBooksLoading = false
        }.resume()
    }
    
    var body: some View {
        VStack {
            Spacer()
            Button(action: { getBooksFromServer() }) {
                if (!serverBooksLoading) {
                    RoundedRectangle(cornerRadius: 8)
                        .overlay(
                            Text("Load books")
                                .foregroundColor(.white)
                        )
                }
            }
            .frame(width: 350, height: 40)
            .padding(.bottom, 20)
        }
    }
}

struct SearchBar: View {
    @Binding var searchText: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .foregroundColor(.white)
            .frame(width: UIScreen.main.bounds.width - 16 * 2, height: 38)
            .shadow(radius: 4)
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search for books, authors", text: $searchText)
                        .font(.body)
                    if (searchText != "") {
                        Image(systemName: "xmark.circle.fill")
                    }
                }
                .padding(.horizontal, 8)
                .foregroundColor(.gray)
            )
    }
}
