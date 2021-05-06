//
//  AuthData.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 06.05.2021.
//

import Foundation

class AuthData: ObservableObject {
    @Published var credentials: AuthCredentials?
    @Published var authState: ViewState = .none
    private(set) var isPreview = false
    var isLoggedIn: Bool {
        credentials != nil
    }
    
    #warning("TODO: LogIn")
    func login(username: String, password: String) {
        guard !isPreview else { return }
        authState = .loading
        credentials = .init(user: User.default, token: "Bearer")
        authState = .result
    }
    
    #warning("TODO: SignUp")
    func signup(name: String, username: String, password: String) {
        guard !isPreview else { return }
        authState = .loading
        credentials = .init(user: User.default, token: "Bearer")
        authState = .result
    }
}

extension AuthData {
    static let preview: AuthData = {
        let authData = AuthData()
        authData.isPreview = true
        authData.credentials = .init(user: User.default, token: "Not Actual Bearer")
        return authData
    }()
}

extension AuthData {
    struct AuthCredentials {
        var user: User
        var token: String
    }
}
