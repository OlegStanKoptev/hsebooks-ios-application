//
//  WhatToReadStand.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 14.03.2021.
//

import SwiftUI
import Combine

class WhatToReadStandLoader: ObservableObject {
    struct BookStandRowItemData: Identifiable {
        let id = UUID()
        var book: BookBase
    }
    struct BookStandRowData: Identifiable {
        let id = UUID()
        var title: String = "Row Title"
        var items: [BookStandRowItemData]
    }
    
    @Published var books: [BookStandRowData] = []
    
    init() { getNewData() }
    
    func getNewData() {
        print("Getting new data for What To Read stand!")
        Networking.shared.loadStandRows { rows in
            self.books =
                rows.map { row in
                    .init(
                        title: row.0,
                        items:
                            row.1.map { book in
                                BookStandRowItemData(book: book)
                            }
                    )
                }
            
            print("Data for What To Read stand succesfully loaded!")
        }
    }
}

struct WhatToReadStand: View {
    typealias BookStandRowItemData = WhatToReadStandLoader.BookStandRowItemData
    typealias RowData = WhatToReadStandLoader.BookStandRowData
    
    let adContent: [Image] = [
        Image("Ad1"),
        Image("Ad2"),
        Image("Ad3"),
        Image("Ad4"),
    ]
    
    @StateObject var loader: WhatToReadStandLoader = WhatToReadStandLoader()
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.vertical) {
                AdSection(images: adContent)
                
                if loader.books.isEmpty {
                    ProgressView()
                        .padding(.top, 64)
                } else {
                    ForEach(loader.books) { row in
                        VStack(spacing: 4) {
                            NavigationLink(
                                destination: StandList(title: row.title),
                                label: {
                                    HStack(spacing: 4) {
                                        Text(row.title)
                                            .font(.system(size: 15))
                                            .textCase(.uppercase)
                                            .foregroundColor(.orange)
                                        Image(systemName: "chevron.forward")
                                            .font(.system(size: 13))
                                            .foregroundColor(.secondary)
                                        Spacer()
                                    }
                                }
                            )
                            .padding(.horizontal, 16)
                            
                            HStack {
                                ForEach(row.items) { item in
                                    NavigationLink(
                                        destination: BookPage(book: item.book),
                                        label: {
                                            BookStandItem(book: item.book)
                                        })
                                        .buttonStyle(SlightlyPressedButtonStyle())
                                }
                            }
                            .padding(.horizontal, 12)
                        }
                    }
                    
                }
                Color.clear
                    .frame(height: 16)
            }
            
//            TabBar(tabBarContext: tabBarContext)
        }
        .onAppear {
//            Networking.shared.loadStandRows { rows in
//                standRows =
//                    rows.map { row in
//                        .init(
//                            title: row.0,
//                            items:
//                                row.1.map { book in
//                                    BookStandRowItemData(book: book)
//                                }
//                        )
//                    }
//            }
        }
    }
}

struct WhatToReadStand_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WhatToReadStand()
        }
//            .environmentObject(TabBarContext())
    }
}
