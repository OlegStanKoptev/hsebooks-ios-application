//
//  BookListContent.swift
//  BookExchange
//
//  Created by Oleg Koptev on 25.01.2021.
//

import SwiftUI

struct BookListContent: View {
//    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(fetchRequest: BookBase.booksOnHomeScreen(), animation: .default)
    private var books: FetchedResults<BookBase>
    
    var localBooks: [BookBase_deprecated]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(spacing: 8) {
                Ad()
                BookListSection(header: "Local books", books: localBooks)
                BookListLoadableSection(header: "Books from server")
                
                VStack {
                    HStack {
                        Text("Books from db")
                        Spacer()
                    }
                    .foregroundColor(.orange)
                    .padding(.leading, 16)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(books) { book in
                                Text(book.title ?? "nil")
                            }
                        }
                    }
                }
                
                Color.clear.frame(height: 100)
            }
        }
    }
}

struct BookListContent_Previews: PreviewProvider {
    static var previews: some View {
        BookListContent(localBooks: [])
            .environmentObject(AppContext())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
