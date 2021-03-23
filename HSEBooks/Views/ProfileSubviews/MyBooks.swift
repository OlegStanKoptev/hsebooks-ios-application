//
//  MyBooks.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 22.03.2021.
//

import SwiftUI

struct MyBooks: View {
    struct ListRowData: Identifiable {
        let id = UUID()
        var title: String = "Title"
        var author: String = "Author"
        var rating: Double = 0.0
        var publishYear: Int = 2021
    }
    
    typealias RowData = ListRowData
    typealias MenuItem = BookListRowWithMenu.Action
    
    let title: String = "My Books"
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
        .init(label: "Edit", imageName: "pencil", onPressed: {
            print("Edit")
        }),
        .init(label: "Remove", imageName: "trash", onPressed: {
            print("Add to Favorites")
        })
    ]
    
    var body: some View {
        ZStack {
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
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    NavigationLink(
                        destination: NewBook(),
                        label: {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .font(.system(size: 40))
                                .padding(12)
                                .background(
                                    Circle()
                                        .fill(Color("Orange"))
                                        .shadow(radius: 3, y: 2)
                                )
                        }
                    )
                    .buttonStyle(SlightlyPressedButtonStyle())
                }
            }
            .padding()
        }
        .navigationBarHidden(true)
    }
}

struct MyBooks_Previews: PreviewProvider {
    static var previews: some View {
        MyBooks()
    }
}
