//
//  NewBook.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 23.03.2021.
//

import SwiftUI

struct NewBook: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
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
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationBar(title: "Add a Book")
                .navigationBarBackgroundStyle()
            
            ScrollView(.vertical) {
                NewBookForm(name: $name, author: $author, genre: $genre, city: $city, description: $description, images: $images)
                    .padding(.vertical, 24)
                
                
                Button(action: {
                    hideKeyboard()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("SEND")
                }
                .buttonStyle(FilledRoundedButtonStyle(fillColor: .accentColor, verticalPadding: 24))
                .padding(.horizontal, 80)
                
                GeometryReader { _ in
                    Image("ScreenBackground")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .edgesIgnoringSafeArea(.bottom)
                        .opacity(0.25)
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
        .navigationBarHidden(true)
    }
}

struct NewBook_Previews: PreviewProvider {
    static var previews: some View {
        NewBook()
    }
}
