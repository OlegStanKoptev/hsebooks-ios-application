//
//  Networking.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 28.03.2021.
//

import Foundation

class Networking {
    struct Account {
        var username: String
        var password: String
    }
    
    static let shared = Networking()
    
    private init() {}
    
    let useLocalServer = true

    var myAccount = Account(username: "OlegStan", password: "superSecret")
    var authToken: String = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJPbGVnU3RhbiIsImV4cCI6MTYxNzc1NTE3N30.kI0lnwWrMEawfNzL6RV3fj9K1NVETUlooPqTe5SDgwUA45JrIlaGgGcILYaehYaEDrfMWKX6nYgAnsETR-Z0zg"
    let serverUrl = URL(string: "https://books.infostrategic.com")!
    let localServerUrl = URL(string: "http://192.168.1.3:80")!
    var cachedBookBasePhotos: [BookBasePhoto] = []
    var cachedStandWhatToRead: [(String, [BookBase])] = []
    
    var getServerUrl: URL { return useLocalServer ? localServerUrl : serverUrl }
    
    private func makeRequest(to endpoint: String, with params: [String: String] = [:], handler: @escaping (Data) -> Void) {
        var components = URLComponents(string: getServerUrl.appendingPathComponent(endpoint).absoluteString)!
        components.queryItems = [ URLQueryItem(name: "latest", value: "true") ]
        if !params.isEmpty {
            components.queryItems?.append(contentsOf: params.map {
                URLQueryItem(name: $0, value: $1)
            })
        }
        
        var request = URLRequest(url: components.url!)
        request.addValue(authToken, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                self.handleClientError(error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                self.handleServerError(response)
                return
            }
            if let mimeType = httpResponse.mimeType, mimeType == "application/json",
               let data = data {
                handler(data)
            }
        }
        task.resume()
    }
    
    private func handleClientError(_ error: Error) {
        fatalError("Client error while loadign info from server: \(error.localizedDescription)")
    }
    
    private func handleServerError(_ response: URLResponse?) {
        fatalError("Server error occured: \(response.debugDescription)")
    }
    
    func loadBookBasePhoto(id: Int, handler: @escaping (BookBasePhoto) -> Void) {
        if let image = cachedBookBasePhotos.first(where: { $0.id == id }) {
            handler(image)
        } else {
            makeRequest(to: "bookBasePhoto/\(id)") { data in
                if let result = try? JSONDecoder().decode(BookBasePhoto.self, from: data) {
                    self.cachedBookBasePhotos.append(result)
                    DispatchQueue.main.async {
                        handler(result)
                    }
                }
            }
        }
    }
    
    func loadBookBase(limit: Int = 0, skip: Int = 0, handler: @escaping ([BookBase]) -> Void) {
        var params: [String: String] = [:]
        if limit != 0 {
            params["limit"] = String(limit)
        }
        if skip != 0 {
            params["skip"] = String(skip)
        }
        
        makeRequest(
            to: "bookBase",
            with: params
        ) { data in
            if let result = try? JSONDecoder().decode([BookBase].self, from: data) {
                DispatchQueue.main.async {
                    handler(result)
                }
            }
        }
    }
    
    func loadStandRows(handler: @escaping ([(String, [BookBase])]) -> Void) {
        let limit = String(3)
        let paramsRecommended: [String: String] = [ "limit": limit, "recommended": "true" ]
//        let paramsPopular: [String: String] = [ "limit": limit, "popular": "true" ]
        let paramsNew: [String: String] = [ "limit": limit ]
        
        if !cachedStandWhatToRead.isEmpty {
            handler(cachedStandWhatToRead)
        }
        
        makeRequest(to: "bookBase", with: paramsRecommended) { data1 in
//            self.makeRequest(to: "bookBase", with: paramsPopular) { data2 in
                self.makeRequest(to: "bookBase", with: paramsNew) { data3 in
                    if let result1 = try? JSONDecoder().decode([BookBase].self, from: data1),
//                       let result2 = try? JSONDecoder().decode([BookBase].self, from: data2),
                       let result3 = try? JSONDecoder().decode([BookBase].self, from: data3) {
                        let result = [
                            ("Recommended", result1),
//                            ("Popular", result2),
                            ("New", result3)
                        ]
                        
                        self.cachedStandWhatToRead = result
                        DispatchQueue.main.async {
                            handler(result)
                        }
                    }
                }
//            }
        }
    }
}
