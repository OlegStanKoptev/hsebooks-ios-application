//
//  WhatToReadStand.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 14.03.2021.
//

import SwiftUI

struct WhatToReadStand: View {
    struct BookStandRowItemData: Identifiable {
        let id = UUID()
        var title: String = "Title"
        var author: String = "Author"
        var rating: Double = 0.0
        var publishYear: Int = 2021
    }
    struct BookStandRowData: Identifiable {
        let id = UUID()
        var title: String = "Row Title"
        var items: [BookStandRowItemData]
    }
    
    typealias RowData = BookStandRowData
    
    let adContent: [Image] = [
        Image("Ad1"),
        Image("Ad2"),
        Image("Ad3"),
        Image("Ad4"),
    ]
    let standRows: [RowData] = [
        .init(items: [
            .init(),
            .init(),
            .init(),
        ]),
        .init(items: [
            .init(),
            .init(),
            .init(),
        ]),
        .init(items: [
            .init(),
            .init(),
            .init(),
        ]),
    ]
    var body: some View {
        Group {
            ScrollView(.vertical) {
                AdSection(images: adContent)
                ForEach(standRows) { row in
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
                                BookStandItem(title: item.title, author: item.author, rating: item.rating, publishYear: item.publishYear)
                            }
                        }
                        .padding(.horizontal, 12)
                    }
                }
                Color.clear
                    .frame(height: 16)
            }
        }
    }
}

struct WhatToReadStand_Previews: PreviewProvider {
    static var previews: some View {
        WhatToReadStand()
    }
}
