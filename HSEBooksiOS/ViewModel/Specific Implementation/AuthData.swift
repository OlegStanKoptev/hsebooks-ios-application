//
//  AuthData.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 04.05.2021.
//

import Foundation

class AuthData: ObservableObject {
    @Published var currentUser: User?
    @Published var token: String?
    @Published var authState: ViewState = .none
    private(set) var isPreview: Bool = false
    
    var isLoggedIn: Bool {
        currentUser != nil && token != nil
    }
    
    static let preview: AuthData = {
        let auth = AuthData()
        auth.isPreview = true
        auth.currentUser = .default
        auth.token = "Bearer"
        return auth
    }()
    
    private func authRequest(to endpoint: String, with body: [String: String]) {
        guard !isPreview else { return }
        authState = .loading
        RequestService.shared.makeAuthRequest(to: endpoint, with: body) { [weak self] (result: Result<(User, String), RequestError>) in
            switch result {
            case .failure(let error):
                self?.authState = .error(error.description)
            case .success(let (user, token)):
                self?.currentUser = user
                if !token.isEmpty {
                    self?.token = token
                }
                self?.authState = .result
            }
        }
    }
    
    func updateProfileInfo(handler: (() -> Void)? = nil) {
        guard !isPreview, let token = token else { return }
        DispatchQueue.main.async {
            self.authState = .loading
        }
        RequestService.shared.makeRequest(to: User.me.endpoint, using: token) { [weak self] (result: Result<User, RequestError>) in
            switch result {
            case .failure(let error):
                self?.authState = .error(error.description)
            case .success(let user):
                self?.currentUser = user
                self?.authState = .result
            }
            handler?()
        }
    }
    
    func login(username: String, password: String) {
        authRequest(
            to: User.login.endpoint,
            with: [ "username": username, "password": password ]
        )
    }
    
    func signup(name: String, username: String, password: String) {
        authRequest(
            to: User.signup.endpoint,
            with: [ "username": username, "password": password, "name": name ]
        )
    }
    
    func logout() {
        guard !isPreview else { return }
        currentUser = nil
        token = nil
    }
}
