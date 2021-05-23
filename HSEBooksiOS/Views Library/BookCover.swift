//
//  BookCover.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 15.05.2021.
//

import SwiftUI

struct BookCover: View {
    enum CoverType {
        case bookPhoto
        case bookBasePhoto
    }
    var id: Int?
    var type: CoverType
    
    @ObservedObject var appContext = AppContext.shared
    @State private var isLoading: Bool = false
    @State private var image: Image?
    private let errorPlaceholder = Image(systemName: "xmark.circle")
    private let loadingPlaceholder = Image(systemName: "arrow.down.circle")
    
    private func saveImage(data: Data) {
        image = Image(uiImage: UIImage(data: data)!)
        isLoading = false
    }
    
    private func fetch() {
        guard let id = id else { return }
        isLoading = true
        switch type {
        case .bookBasePhoto:
            ImageStorage.shared.getBookBaseCover(for: id, with: appContext) { photo in
                saveImage(data: Data(base64Encoded: photo.image)!)
            }
        case .bookPhoto:
            ImageStorage.shared.getBookCover(for: id, with: appContext) { photo in
                saveImage(data: Data(base64Encoded: photo.image)!)
            }
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            if let image = image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(4)
                    .frame(width: geo.size.width, height: geo.size.height)
            } else {
                if isLoading {
                    loadingPlaceholder
                        .resizable()
                        .foregroundColor(Color(.systemGray3))
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geo.size.width * 0.5)
                        .position(x: geo.size.width / 2, y: geo.size.height / 2)
                } else {
                    errorPlaceholder
                        .resizable()
                        .foregroundColor(Color(.systemGray3))
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geo.size.width * 0.5)
                        .position(x: geo.size.width / 2, y: geo.size.height / 2)
                }
            }
        }
        .aspectRatio(75 / 100, contentMode: .fit)
        .onAppear { fetch() }
    }
}

struct BookCover_Previews: PreviewProvider {
    static var previews: some View {
        BookCover(id: 52, type: .bookBasePhoto)
            .previewLayout(.sizeThatFits)
    }
}
