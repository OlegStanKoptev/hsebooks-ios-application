//
//  StandList.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 14.03.2021.
//

import SwiftUI

struct StandList: View {
    struct BookStandListRowData: Equatable, Identifiable {
        let id = UUID()
        var base: BookBase = .previewInstance
    }
    
    typealias RowData = BookStandListRowData
    typealias MenuItem = BookListRowWithMenu.Action
    
//    @EnvironmentObject var tabBarContext: TabBarContext
    var title: String
    @State var query: String = ""
    
    @State var items: [RowData] = []
    
    @State var moreBooks: Bool = true
    
    let contextMenu: [MenuItem] = [
        .init(label: "Request", imageName: "paperplane", onPressed: {
            print("Request")
        }),
        .init(label: "Add To Favorites", imageName: "heart", onPressed: {
            print("Add to Favorites")
        })
    ]
    
    func getMoreBooks() {
        
//        Networking.shared.loadBookBase(limit: 10, skip: items.count) { books in
//            if books.isEmpty {
//                moreBooks = false
//            } else {
//                items.append(contentsOf: books.map { book in
//                    BookStandListRowData(base: book)
//                })
//            }
//        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Group {
                SearchBar(query: $query)
                NavigationBar(title: title)
            }
            .navigationBarBackgroundStyle()
            
            ScrollView(.vertical) {
                LazyVStack(spacing: 0) {
                    if items.isEmpty {
                        ProgressView()
                            .padding(.top, 32)
                    } else {
                        ForEach(items) { item in
                            BookListRowWithMenu(book: item.base, height: 120, actions: contextMenu)
                                .onAppear {
                                    if items.last! == item && moreBooks {
                                        getMoreBooks()
                                    }
                                }
                        }
                        
                        if moreBooks {
                            ProgressView()
                                .padding(.vertical, 16)
                        }
                    }
                }
                .padding(.vertical, 4)
            }
            
            Spacer(minLength: 0)
        
//            TabBar(tabBarContext: tabBarContext)
        }
        .navigationBarHidden(true)
        .onAppear {
            Networking.shared.loadBookBase(limit: 10) { books in
                items = books.map { book in
                    BookStandListRowData(base: book)
                }
            }
        }
    }
}

struct StandList_Previews: PreviewProvider {
    static var previews: some View {
        StandList(title: "Title")
//            .environmentObject(TabBarContext())
    }
}
