//
//  BookCoverService.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 08.04.2021.
//

import Foundation

class BookCoverService {
    static let shared = BookCoverService()
    
    private init() {}
    var cachedBookBasePhotos: [BookBasePhoto] = []
    func loadBookBasePhoto(id: Int, handler: @escaping (BookBasePhoto) -> Void) {
        if let image = cachedBookBasePhotos.first(where: { $0.id == id }) {
            handler(image)
        } else {
            RequestService.shared.makeRequest(to: "bookBasePhoto/\(id)", with: [:], using: AuthorizationService.shared) { result, decoder in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let data):
                    if let result = try? decoder.decode(BookBasePhoto.self, from: data) {
                        self.cachedBookBasePhotos.append(result)
                        DispatchQueue.main.async {
                            handler(result)
                        }
                    }
                }
            }
        }
    }
}
