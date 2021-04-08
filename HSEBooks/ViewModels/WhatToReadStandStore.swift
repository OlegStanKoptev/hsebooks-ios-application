//
//  WhatToReadStandStore.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 03.04.2021.
//

import Foundation

final class WhatToReadStandStore: ObservableObject {
    struct RowItemData: Identifiable {
        let id = UUID()
        var book: BookBase
    }
    struct RowData: Identifiable {
        let id = UUID()
        var title: String
        var items: [RowItemData]
    }
    
    @Published private(set) var shelves: [RowData] = []
    @Published private(set) var error: Error?
    @Published private(set) var isLoading: Bool = false
    private var cachedShelves: [RowData]?
    
    private let service: BookStandService
    init(service: BookStandService = BookStandService()) {
        self.service = service
    }
    
    func fetch() {
        if let cachedShelves = cachedShelves {
            shelves = cachedShelves
        } else {
            isLoading = true
        }
        
        service.fetchMainStandBooks(with: ["limit": "3", "recommended": "true", "latest": "true" ]) { result1 in
            self.service.fetchMainStandBooks(with: ["limit": "3", "latest": "true" ]) { result2 in
                DispatchQueue.main.async {
                    self.isLoading = false
                    if case .success(let books1) = result1,
                       case .success(let books2) = result2 {
                        self.error = nil
                        self.shelves = [
                            .init(title: "Recommended", items: books1.map { RowItemData(book: $0) }),
                            .init(title: "New", items: books2.map { RowItemData(book: $0) })
                        ]
                        self.cachedShelves = self.shelves
                    } else {
                        if case .failure(let error) = result1 {
                            self.error = error
                        } else if case .failure(let error) = result2 {
                            self.error = error
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                            self.error = nil
                        }
                        self.shelves = []
                    }
                }
            }
        }
    }
}
