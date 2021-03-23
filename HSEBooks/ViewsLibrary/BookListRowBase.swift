//
//  BookListRowBase.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 12.03.2021.
//

import SwiftUI

struct BookListRowBase<Content: View>: View {
    let title: String
    let author: String
    let image: Image?
    let height: CGFloat
    let trailingPadding: CGFloat
    let bottomView: Content
    
    init(title: String, author: String, image: Image? = nil, height: CGFloat, trailingPadding: CGFloat, @ViewBuilder bottom: () -> Content) {
        self.title = title
        self.author = author
        self.image = image
        self.height = height
        self.trailingPadding = trailingPadding
        bottomView = bottom()
    }
    
    private let placeHolder = Image(systemName: "xmark.circle")
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .padding(.vertical, 6)
                .shadow(color: Color.black.opacity(0.5), radius: 4)
            HStack {
                BookCover(image: image)
                .frame(width: 88)
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .padding(.trailing, 16)
                    Group {
                        Text(author)
                        bottomView
                    }
                    .foregroundColor(Color(.lightGray))
                }
                .font(.system(size: 15))
                .lineLimit(1)
                .padding(.trailing, trailingPadding)
                Spacer()
            }
        }
        .frame(height: height)
    }
}

struct BookListRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 0) {
            ForEach(0..<4) { _ in
                BookListRowBase(title: "Title", author: "Author", height: 120, trailingPadding: 0) {
                    EmptyView()
                }
            }
        }
        .previewLayout(.sizeThatFits)
    }
}
