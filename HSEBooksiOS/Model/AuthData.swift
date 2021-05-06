//
//  AuthData.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 06.05.2021.
//

import Foundation
import SwiftUI

class AuthData: ObservableObject {
    @Published var credentials: AuthCredentials?
    @Published var authState: ViewState = .none
    private(set) var isPreview = false
    var isLoggedIn: Bool {
        credentials != nil
    }
    
    func updateUserInfo(handler: @escaping (Result<Void, RequestError>) -> Void) {
        guard !isPreview, let token = credentials?.token else { return }
        RequestService.shared.makeRequest(to: User.me.endpoint, using: token) { [weak self] (result: Result<User, RequestError>) in
            switch result {
            case .failure(let error):
                handler(.failure(error))
            case .success(let user):
                self?.credentials = AuthCredentials(user: user, token: token)
                handler(.success(Void()))
            }
        }
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
