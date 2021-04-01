//
//  GenresStand.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 14.03.2021.
//

import SwiftUI

struct GenresStand: View {
    typealias ItemData = String
//    @EnvironmentObject var tabBarContext: TabBarContext
    let items: [String] = [
        .init("Genre 1"),
        .init("Genre 2"),
        .init("Genre 3"),
        .init("Genre 4"),
        .init("Genre 5"),
        .init("Genre 6"),
        .init("Genre 7"),
    ]
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    ForEach(items, id: \.self) { item in
                        VStack(spacing: 0) {
                            NavigationLink(
                                destination: StandList(title: item),
                                label: {
                                    HStack(spacing: 0) {
                                        Text(item)
                                            .foregroundColor(.primary)
                                            .padding(.vertical, 10)
                                        Spacer()
                                        Image(systemName: "chevron.forward")
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(.horizontal, 16)
                                })
                            
                            Rectangle()
                                .fill(Color(.separator))
                                .frame(height: 1)
                        }
                    }
                }
            }
            
//            TabBar(tabBarContext: tabBarContext)
        }
    }
}

struct GenresStand_Previews: PreviewProvider {
    static var previews: some View {
        GenresStand()
//            .environmentObject(TabBarContext())
    }
}
