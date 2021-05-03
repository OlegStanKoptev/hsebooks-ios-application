//
//  GenresPage.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 29.04.2021.
//

import SwiftUI

struct GenresPage: View {
    @EnvironmentObject var model: GenreData
    var body: some View {
        NavigationView {
            List(model.genres) { genre in
                NavigationLink(destination: BookList(credentials: Genre.genreCredentials(for: genre.id, title: genre.name))) {
                    Text(genre.name)
                }
            }
            .overlay(
                Group {
                    switch model.viewState {
                    case .none, .result:
                        EmptyView()
                    case .loading:
                        SpinnerView()
                    case .error(let message):
                        TextOverlay(text: message)
                    }
                }
            )
            .navigationTitle(Genre.all.name)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct GenresPage_Previews: PreviewProvider {
    static var previews: some View {
        GenresPage()
            .environmentObject(GenreData.preview)
    }
}
