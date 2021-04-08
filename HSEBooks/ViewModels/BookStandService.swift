//
//  BookStandService.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 03.04.2021.
//

import Foundation

class BookStandService {
//    init() {}
    
    func fetchMainStandBooks(with params: [String: String] = [:], handler: @escaping (Result<[BookBase], RequestService.RequestError>) -> Void) {
        RequestService.shared.makeRequest(to: "bookBase", with: params, using: AuthorizationService.shared) { result, decoder in
            switch result {
            case .failure(let error):
                handler(.failure(error))
            case .success(let data):
                do {
                    let books = try decoder.decode([BookBase].self, from: data)
                    handler(.success(books))
                } catch {
                    handler(.failure(.client(error)))
                }
            }
        }
    }
}

