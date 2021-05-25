//
//  AppContext.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 06.05.2021.
//

import Foundation
import SwiftUI

class AppContext: ObservableObject {
    private let defaultServerAddress = "https://books.infostrategic.com"
    private let settingsServerAddressId = "server_address"
    static let shared = AppContext()
    
    @Published var splashScreenPresented: Bool = true
    @Published var searchIsPresented: Bool = false
    
    // Variables for authorization logic
    @Published var credentials: AuthCredentials?
    @Published var authViewState: ViewState = .none
    
    // Genres storage
    @Published var genres: [Genre] = []
    
    // Towns storage
    @Published var towns: [Town] = []
    
    // Exterior Quality storage
    @Published var quality: [ExteriorQuality] = []
    
    // Preview indicator for dependent view models
    private(set) var isPreview = false
}

// MARK: - Authorization Logic
extension AppContext {
    struct AuthCredentials: Codable {
        var user: User
        var token: String
    }
    
    var isLoggedIn: Bool {
        credentials != nil && authViewState == .none
    }
    
    private func authRequest(to endpoint: String, with body: [String: String]) {
        guard !isPreview, authViewState != .loading else { return }
        guard body.values.allSatisfy({!$0.isEmpty}) else {
            authViewState = .error("All fields are mandatory")
            return
        }
        authViewState = .loading
        RequestService.shared.makeAuthRequest(to: endpoint, with: body) { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .failure(let error):
                    self?.authViewState = .error(error.description)
                case .success(let (user, token)):
                    self?.fetchGenres(token: token) {
                        self?.fetchTowns(token: token) {
                            self?.fetchQualities(token: token) {
                                self?.credentials = AuthCredentials(user: user, token: token)
                                self?.authViewState = .none
                            }
                        }
                    }
                }
            }
        }
    }
    
    func fullUpdate(with token: String, handler: @escaping () -> Void) {
        guard !isPreview, authViewState != .loading else { return }
        RequestService.shared.makeRequest(to: User.me.endpoint, using: token) { [weak self] (result: Result<User, RequestError>) in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .failure(_): break
                case .success(let user):
                    self?.fetchGenres(token: token) {
                        self?.fetchTowns(token: token) {
                            self?.fetchQualities(token: token) {
                                self?.credentials = AuthCredentials(user: user, token: token)
                                handler()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func updateUserInfo(handler: @escaping (Result<Void, RequestError>) -> Void = {_ in}) {
        guard !isPreview, let token = credentials?.token else { return }
        RequestService.shared.makeRequest(to: User.me.endpoint, using: token) { [weak self] (result: Result<User, RequestError>) in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .failure(let error):
                    handler(.failure(error))
                case .success(let user):
                    self?.credentials = AuthCredentials(user: user, token: token)
                    handler(.success(Void()))
                }
            }
        }
    }
    
    func login(username: String, password: String) {
        guard !isPreview else { return }
        authRequest(to: User.login.endpoint, with: ["username": username, "password": password])
    }
    
    func signup(name: String, username: String, password: String) {
        guard !isPreview else { return }
        authRequest(to: User.signup.endpoint, with: ["name": name, "username": username, "password": password])
    }
    
    func logOut() {
        guard !isPreview else { return }
        credentials = nil
        genres = []
        towns = []
        quality = []
    }
}

// MARK: - Genres loader
extension AppContext {
    func fetchGenres(token: String, handler: @escaping () -> Void = {}) {
        guard !isPreview else { return }
        RequestService.shared.makeRequest(to: Genre.all.endpoint, with: Genre.all.params, using: token) { [weak self] (result: Result<[Genre], RequestError>) in
            switch result {
            case .failure(let error):
                self?.authViewState = .error(error.description)
            case .success(let genres):
                self?.genres = genres
                handler()
            }
        }
    }
}

// MARK: - Towns Loader
extension AppContext {
    func fetchTowns(token: String, handler: @escaping () -> Void = {}) {
        guard !isPreview else { return }
        RequestService.shared.makeRequest(to: Town.all.endpoint, with: Town.all.params, using: token) { [weak self] (result: Result<[Town], RequestError>) in
            switch result {
            case .failure(let error):
                self?.authViewState = .error(error.description)
            case .success(let towns):
                self?.towns = towns
                handler()
            }
        }
    }
}

// MARK: - Exterior Qualities Loader
extension AppContext {
    func fetchQualities(token: String, handler: @escaping () -> Void = {}) {
        guard !isPreview else { return }
        RequestService.shared.makeRequest(to: ExteriorQuality.all.endpoint, with: ExteriorQuality.all.params, using: token) { [weak self] (result: Result<[ExteriorQuality], RequestError>) in
            switch result {
            case .failure(let error):
                self?.authViewState = .error(error.description)
            case .success(let quality):
                self?.quality = quality
                handler()
            }
        }
    }
}

// MARK: - Wishlist Logic
extension AppContext {
    func isWished(_ bookBase: BookBase) -> Bool {
        bookBase.wishersIds.contains(credentials?.user.id ?? 0)
    }
    
    func toggleWishlist(of bookBase: BookBase, viewState: Binding<ViewState>, handler: @escaping (Bool) -> Void) {
        guard !isPreview, let token = credentials?.token else { return }
        viewState.wrappedValue = .loading
        let method = self.isWished(bookBase) ? "DELETE" : "POST"
        
        RequestService.shared.makeRequestWithoutResponse(to: User.wishlist.endpoint, authToken: token, method: method, params: ["baseId": String(bookBase.id)]) { result in
            switch result {
            case .failure(let error):
                viewState.wrappedValue = .error(error.description)
            case .success(_):
                handler(!self.isWished(bookBase))
                viewState.wrappedValue = .none
            }
        }
    }
}

extension AppContext {
    func rateBook(_ bookBase: BookBase, viewState: Binding<ViewState>, stars: Int, handler: @escaping (Double) -> Void) {
        guard !isPreview, let token = credentials?.token else { return }
        viewState.wrappedValue = .loading
        let body = Review.PostReview(ratedBookBaseId: bookBase.id, rate: Double(stars), body: "")
        
        RequestService.shared.makePostRequest(to: BookBase.rating.endpoint, with: token, body: body) { (result: Result<Review, RequestError>) in
            switch result {
            case .failure(let error):
                viewState.wrappedValue = .error(error.description)
            case .success(let review):
                handler(review.rate)
                viewState.wrappedValue = .none
            }
        }
    }
}

// MARK: - Read Custom Values From Settings Bundle
extension AppContext {
    func getSettingsValues() {
        if let serverAddress = UserDefaults.standard.string(forKey: settingsServerAddressId),
           let url = URL(string: serverAddress) {
//            print("Found custom settings: server address is \(serverAddress)")
            RequestService.configure(serverUrl: url)
        } else {
//            print("Custom settings were incorrect: server address is set to \(defaultServerAddress)")
            UserDefaults.standard.setValue(defaultServerAddress, forKey: settingsServerAddressId)
            RequestService.configure(serverUrl: URL(string: defaultServerAddress)!)
        }
    }
}

// MARK: - Preview Setup
extension AppContext {
    static let preview: AppContext = {
        let appContext = AppContext()
        appContext.isPreview = true
        appContext.credentials = .init(user: User.default, token: "Not Actual Bearer")
        appContext.genres = Genre.getItems(amount: 3)
        appContext.towns = Town.getItems(amount: 3)
        appContext.quality = ExteriorQuality.getItems(amount: 5)
        return appContext
    }()
}
