//
//  BookList.swift
//  BookExchange
//
//  Created by Oleg Koptev on 21.01.2021.
//

import SwiftUI

struct BookList: View {
    @EnvironmentObject var context: AppContext
    @State var searchText: String = ""
    var localBooks: [BookBase] = [
        BookBase(id: 1, author: "Author", language: "ENG", title: "Title", numberOfPages: 1, publishYear: 1, wishers: [], genres: [], rating: 5.0)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            BookListSelector()
            ZStack {
                BookListContent(localBooks: localBooks)
                LoadBooksButton()
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
            .environmentObject(AppContext())
    }
}
