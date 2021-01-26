//
//  BooksLoader.swift
//  BookExchange
//
//  Created by Oleg Koptev on 26.01.2021.
//

import Foundation

class BooksLoader: BooksLoading {
    func load(_ handler: @escaping ([BookBase]) -> Void) {
        var request = URLRequest(url: Constants.allBooks, timeoutInterval: 10)
        request.addValue(Constants.authToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, _, _) in
            guard let data = data else { return }
            let books = try? JSONDecoder().decode([BookBase].self, from: data)
            DispatchQueue.main.async {
                handler(books ?? [])
            }
        }
        task.resume()
    }
}
