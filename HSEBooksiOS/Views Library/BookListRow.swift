//
//  BookListRow.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 16.05.2021.
//

import SwiftUI

struct BookListRow<C1: View, C2: View>: View {
    var title: String = "Title"
    var author: String = "Author"
    var isHearted: Bool = false
    var photoId: Int? = nil
    var coverType: BookCover.CoverType = .bookBasePhoto
    var thirdLine: C1
    var fourthLine: C2
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .padding(.vertical, 6)
                .shadow(color: Color.black.opacity(0.5), radius: 4)
            
            HStack(spacing: 6) {
                BookCover(id: photoId, type: coverType)
                    .padding(.vertical, 4)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .foregroundColor(.primary) +
                    Text("  ") + 
                    Text(Image(systemName: "heart.fill"))
                        .foregroundColor(isHearted ? .red : .clear)
//                        .padding(.trailing, 16)
                    
                    Group {
                        Text(author)
                        thirdLine
                        fourthLine
                    }
                    .foregroundColor(Color(.lightGray))
                }
                .font(.system(size: 15))
                .lineLimit(1)
                .padding(.trailing, 16)
                
                Spacer()
            }
        }
        .frame(height: 120)
    }
}

struct BookListRow_Previews: PreviewProvider {
    static var previews: some View {
        BookListRow(
            thirdLine: Text("123"),
            fourthLine: Text("123")
        )
    }
}
