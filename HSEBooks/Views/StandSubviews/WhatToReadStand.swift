//
//  WhatToReadStand.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 14.03.2021.
//

import SwiftUI

struct WhatToReadStand: View {
    typealias RowItemData = WhatToReadStandStore.RowItemData
    typealias RowData = WhatToReadStandStore.RowData
    
    let adContent: [Image] = [
        Image("Ad1"),
        Image("Ad2"),
        Image("Ad3"),
        Image("Ad4"),
    ]
    
    @EnvironmentObject var store: WhatToReadStandStore
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.vertical) {
                AdSection(images: adContent)
                
                if store.isLoading {
                    ProgressView()
                        .padding(.top, 64)
                } else {
                    ForEach(store.shelves) { shelve in
                        VStack(spacing: 4) {
                            NavigationLink(
                                destination: StandList(title: shelve.title),
                                label: {
                                    HStack(spacing: 4) {
                                        Text(shelve.title)
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
                                ForEach(shelve.items) { item in
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
        }
        .overlay(
            Group {
                if let error = store.error {
                    Text(error.localizedDescription)
                        .padding()
                        .multilineTextAlignment(.center)
                        .background(Color(.secondarySystemFill))
                        .cornerRadius(4)
                        .padding(64)
                }
            }
        )
        .onAppear { store.fetch() }
    }
}

struct WhatToReadStand_Previews: PreviewProvider {
    static var previews: some View {
        WhatToReadStand()
            .environmentObject(WhatToReadStandStore())
    }
}
