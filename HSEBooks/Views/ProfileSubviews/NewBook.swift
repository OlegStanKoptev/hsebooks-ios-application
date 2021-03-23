//
//  NewBook.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 23.03.2021.
//

import SwiftUI

struct NewBook: View {
    init() {
        UITextView.appearance().backgroundColor = .clear
        UITextView.appearance().contentInset.top = -8
        UITextView.appearance().contentInset.left = -5
        UITextView.appearance().contentInset.right = -5
        UITextView.appearance().contentInset.bottom = -8
    }
    
    @State var name: String = ""
    @State var author: String = ""
    @State var genre: String = ""
    @State var city: String = ""
    @State var description: String = ""
    @State var images: [String] = [ "Image1.jpg" ]
    var body: some View {
        VStack(spacing: 0) {
            NavigationBar(title: "Add a Book")
                .navigationBarBackgroundStyle()
            
            ScrollView(.vertical) {
                NewBookForm(name: $name, author: $author, genre: $genre, city: $city, description: $description, images: $images)
                    .padding(.vertical, 24)
                
                
                Button(action: {}) {
                    Text("SEND")
                }
                .buttonStyle(FilledRoundedButtonStyle(fillColor: Color("Orange"), verticalPadding: 24))
                .padding(.horizontal, 80)
                
                GeometryReader { _ in
                    Image("ScreenBackground")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .edgesIgnoringSafeArea(.bottom)
                        .opacity(0.25)
                }
            }
        }
    }
}

struct NewBook_Previews: PreviewProvider {
    static var previews: some View {
        NewBook()
    }
}
