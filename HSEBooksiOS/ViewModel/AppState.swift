//
//  AppState.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 04.05.2021.
//

import Foundation
import Combine

class AppState: ObservableObject {
    enum TabPage: String {
        case home
        case genres
        case favorites
        case profile
    }
    
    @Published var authData = AuthData()
    @Published var homeData = HomeData()
    @Published var genresData: PersistentDataViewModel<Genre> = RealPersistentDataViewModel()
    @Published var chosenTab: TabPage = .home
    
    private(set) var isPreview = false
    
    private var anyCancellable = Set<AnyCancellable>()
    
    init() {
        authData.objectWillChange
            .sink { self.objectWillChange.send() }
            .store(in: &anyCancellable)
        homeData.objectWillChange
            .sink { self.objectWillChange.send() }
            .store(in: &anyCancellable)
        genresData.objectWillChange
            .sink { self.objectWillChange.send() }
            .store(in: &anyCancellable)
    }
    
    private func clearCache() {
        homeData.clearCache()
        genresData.clearCache()
    }
    
    func logOut() {
        authData.logout()
        clearCache()
    }
    
    static var preview: AppState = {
        let appState = AppState()
        appState.isPreview = true
        appState.authData = AuthData.preview
        appState.homeData = HomeData.preview
        appState.genresData = MockPersistentDataViewModel<Genre>()
        return appState
    }()
}
