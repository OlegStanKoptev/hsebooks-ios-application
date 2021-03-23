//
//  StandList.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 14.03.2021.
//

import SwiftUI

struct StandList: View {
    struct BookStandListRowData: Identifiable {
        let id = UUID()
        var title: String = "Title"
        var author: String = "Author"
        var rating: Double = 0.0
        var publishYear: Int = 2021
    }
    
    typealias RowData = BookStandListRowData
    typealias MenuItem = BookListRowWithMenu.Action
    
    var title: String
    @State var query: String = ""
    
    let items: [RowData] = [
        .init(),
        .init(),
        .init(),
        .init(),
        .init(),
        .init(),
        .init(),
    ]
    
    let contextMenu: [MenuItem] = [
        .init(label: "Request", imageName: "paperplane", onPressed: {
            print("Request")
        }),
        .init(label: "Add To Favorites", imageName: "heart", onPressed: {
            print("Add to Favorites")
        })
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            Group {
                SearchBar(placeholderText: "Search...", query: $query)
                NavigationBar(title: title)
            }
            .navigationBarBackgroundStyle()
            
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    ForEach(items) { item in
                        BookListRowWithMenu(title: item.title, author: item.author, publishYear: item.publishYear, rating: item.rating, image: nil, height: 120, actions: contextMenu)
                    }
                }
                .padding(.vertical, 4)
            }
            
            Spacer(minLength: 0)
        }
        .navigationBarHidden(true)
    }
}

struct StandList_Previews: PreviewProvider {
    static var previews: some View {
        StandList(title: "Title")
    }
}
