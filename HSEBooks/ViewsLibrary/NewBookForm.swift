//
//  NewBookForm.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 22.03.2021.
//

import SwiftUI

struct NewBookForm: View {
    @Binding var name: String
    @Binding var author: String
    @Binding var genre: String
    @Binding var city: String
    @Binding var description: String
    @Binding var images: [String]
    var body: some View {
        VStack(spacing: 12) {
            TextField("Book name", text: $name)
                .grayRoundedBackground()
            TextField("Author", text: $author)
                .grayRoundedBackground()
            TextField("Genre", text: $genre)
                .grayRoundedBackground()
            TextField("City", text: $city)
                .grayRoundedBackground()
            TextEditor(text: $description)
                .background(
                    VStack {
                        HStack {
                            Text(description.isEmpty ? "Description" : "")
                                .foregroundColor(Color(.systemGray2))
                            Spacer()
                        }
                        Spacer()
                    }
                )
                .frame(height: 134)
                .grayRoundedBackground()
            HStack {
                VStack(alignment: .leading) {
                    Text("Add images")
                        .foregroundColor(.secondary)
                    ForEach(images, id: \.self) { image in
                        HStack {
                            Text(image)
                                .frame(width: 160, height: UIFont.preferredFont(forTextStyle: .body).pointSize, alignment: .leading)
                                .grayRoundedBackground()
                            Image(systemName: "xmark")
                                .frame(width: UIFont.preferredFont(forTextStyle: .body).pointSize, height: UIFont.preferredFont(forTextStyle: .body).pointSize, alignment: .center)
                                .grayRoundedBackground()
                                .foregroundColor(.red)
                        }
                    }
                    HStack {
                        Text("")
                            .frame(width: 160, height: UIFont.preferredFont(forTextStyle: .body).pointSize, alignment: .leading)
                            .grayRoundedBackground()
                        Image(systemName: "plus")
                            .frame(width: UIFont.preferredFont(forTextStyle: .body).pointSize, height: UIFont.preferredFont(forTextStyle: .body).pointSize, alignment: .center)
                            .grayRoundedBackground()
                            .foregroundColor(.blue)
                    }
                }
                Spacer()
            }
        }
        .padding(.horizontal, 16)
    }
}

struct NewBookForm_Previews: PreviewProvider {
    static var previews: some View {
        NewBookForm(name: .constant(""), author: .constant(""), genre: .constant(""), city: .constant(""), description: .constant(""), images: .constant([ "Cover1.jpg" ]))
            .accentColor(Color("Orange"))
            .onAppear {
                UITextView.appearance().backgroundColor = .clear
            }
    }
}
