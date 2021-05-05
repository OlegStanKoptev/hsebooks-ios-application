//
//  GenresPage.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 29.04.2021.
//

import SwiftUI

struct GenresPage: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        NavigationView {
            List(appState.genresData.items) { genre in
                NavigationLink(destination: BookList(credentials: Genre.genreCredentials(for: genre.id, title: genre.name))) {
                    Text(genre.name)
                }
            }
            .overlay(StatusOverlay(viewState: $appState.genresData.viewState))
            .navigationTitle(Genre.all.name)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct GenresPage_Previews: PreviewProvider {
    static var previews: some View {
        GenresPage()
                .environmentObject(AppState.preview)
    }
}
