//
//  BookCover.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 13.03.2021.
//

import SwiftUI

/// BookCover takes image: Image as the only optional argument
struct BookCover: View {
    var photoId: Int?
    @State private var image: Image?
    private let placeHolder = Image(systemName: "xmark.circle")
    var body: some View {
        GeometryReader { geo in
            if let image = image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(4)
                    .frame(width: geo.size.width, height: geo.size.height)
            } else {
                placeHolder
                    .resizable()
                    .foregroundColor(Color(.systemGray3))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geo.size.width * 0.5)
                    .position(x: geo.size.width / 2, y: geo.size.height / 2)
            }
        }
        .aspectRatio(75 / 100, contentMode: .fit)
        .onAppear {
            if let photoId = photoId {
                Networking.shared.loadBookBasePhoto(id: photoId) { bookBasePhoto in
                    image = Image(uiImage: UIImage(data: Data(base64Encoded: bookBasePhoto.image)!)!)
                }
            }
        }
    }
}

struct BookCover_Previews: PreviewProvider {
    static var previews: some View {
        BookCover()
            .previewLayout(.sizeThatFits)
    }
}
