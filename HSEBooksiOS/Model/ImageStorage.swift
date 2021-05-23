//
//  ImageStorage.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 15.05.2021.
//

import Foundation

class ImageStorage {
    static let shared = ImageStorage()
    
    private var cachedBookBaseCovers: [BookBasePhoto] = []
    private var loadingBookBaseCovers = Set<Int>()
    
    private var cachedBookCovers: [BookPhoto] = []
    private var loadingBookCovers = Set<Int>()
    
    private var cachedAvatar: [Avatar] = []
    private var loadingAvatar = Set<Int>()
    
    private func cacheControl() {
        let amountLimit = 50
        let removeFirst = 20
        
        if cachedBookBaseCovers.count > amountLimit {
            cachedBookBaseCovers.removeSubrange(0..<removeFirst)
        }
        if cachedBookCovers.count > amountLimit {
            cachedBookCovers.removeSubrange(0..<removeFirst)
        }
        if cachedAvatar.count > amountLimit {
            cachedBookCovers.removeSubrange(0..<removeFirst)
        }
    }
    
    func getBookBaseCover(for id: Int, with appContext: AppContext, handler: @escaping (BookBasePhoto) -> Void) {
        guard !appContext.isPreview else { return }
        cacheControl()
        guard let token = appContext.credentials?.token else {
            cachedBookBaseCovers = []
            return
        }
        if let cachedCover = cachedBookBaseCovers.first(where: { $0.id == id }) {
            handler(cachedCover)
            return
        }
        guard !loadingBookBaseCovers.contains(id) else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.getBookBaseCover(for: id, with: appContext, handler: handler)
            }
            return
        }

        loadingBookBaseCovers.insert(id)
        
        RequestService.shared.makeRequest(to: "\(BookBasePhoto.all.endpoint)/\(id)", with: [:], using: token) { (result: Result<BookBasePhoto, RequestError>) in
            switch result {
            case .failure(let error):
                print(error.description)
            case .success(let photo):
                self.cachedBookBaseCovers.append(photo)
                self.loadingBookBaseCovers.remove(photo.id)
                handler(photo)
            }
        }
    }
    
    func getBookCover(for id: Int, with appContext: AppContext, handler: @escaping (BookPhoto) -> Void) {
        guard !appContext.isPreview else { return }
        cacheControl()
        guard let token = appContext.credentials?.token else {
            cachedBookCovers = []
            return
        }
        if let cachedCover = cachedBookCovers.first(where: { $0.id == id }) {
            handler(cachedCover)
            return
        }
        guard !loadingBookCovers.contains(id) else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.getBookCover(for: id, with: appContext, handler: handler)
            }
            return
        }

        loadingBookCovers.insert(id)
        
        RequestService.shared.makeRequest(to: "\(BookPhoto.all.endpoint)/\(id)", with: [:], using: token) { (result: Result<BookPhoto, RequestError>) in
            switch result {
            case .failure(let error):
                print(error.description)
            case .success(let photo):
                self.cachedBookCovers.append(photo)
                self.loadingBookCovers.remove(photo.id)
                handler(photo)
            }
        }
    }
    
    func getAvatar(for id: Int, with appContext: AppContext, handler: @escaping (Avatar) -> Void) {
        guard !appContext.isPreview else { return }
        cacheControl()
        guard let token = appContext.credentials?.token else {
            cachedBookCovers = []
            return
        }
        if let cachedAvatar = cachedAvatar.first(where: { $0.id == id }) {
            handler(cachedAvatar)
            return
        }
        guard !loadingAvatar.contains(id) else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.getAvatar(for: id, with: appContext, handler: handler)
            }
            return
        }

        loadingAvatar.insert(id)
        
        RequestService.shared.makeRequest(to: "\(Avatar.avatar.endpoint)/\(id)", with: [:], using: token) { (result: Result<Avatar, RequestError>) in
            switch result {
            case .failure(let error):
                print(error.description)
            case .success(let avatar):
                self.cachedAvatar.append(avatar)
                self.loadingAvatar.remove(avatar.id)
                handler(avatar)
            }
        }
    }
}
