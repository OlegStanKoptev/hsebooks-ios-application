//
//  BookRequest.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 22.03.2021.
//

import SwiftUI

struct BookRequest: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var book: BookBase
    var sendRequestAction: ((String) -> Void)?
    
    @State var message: String = ""
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private func sendButtonPressed() {
        hideKeyboard()
        sendRequestAction?(message)
        presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationBar(title: "Title")
                .padding(.vertical, 4)
                .navigationBarBackgroundStyle()
            
            
            HStack(spacing: 16) {
                BookCover()
                    .frame(height: 100)
                VStack(alignment: .leading, spacing: 4) {
                    Text(book.title)
                    Text(book.author)
                }
                Spacer()
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(
                Rectangle()
                    .fill(Color(.systemGray6))
                    .shadow(radius: 2, y: 2)
            )
            .padding(.bottom, 2)
            
            ScrollView(.vertical) {
                VStack {
                    CustomLabel(text: "Username", image: Image(systemName: "person.circle.fill"), imageColor: Color("SecondColor"))
                    CustomLabel(text: "City", image: Image(systemName: "map.fill"), imageColor: .accentColor)
                    
                    VStack(spacing: 4) {
                        HStack {
                            Text("Please leave a message:")
                            Spacer(minLength: 0)
                        }
                        .foregroundColor(.secondary)
                        .padding(.top, 8)
                        
                        TextEditor(text: $message)
                            .border(Color.gray.opacity(0.5), width: 2)
                            .frame(height: 200)
                    }
                    Button(action: { sendButtonPressed() }, label: {
                        Text("Send a request")
                            .textCase(.uppercase)
                    })
                    .buttonStyle(FilledRoundedButtonStyle(fillColor: .orange, verticalPadding: 18))
                    .padding(.horizontal, 64)
                    .padding(.vertical, 16)
                    
                    Spacer(minLength: 0)
                    
                    GeometryReader { _ in
                        Image("ScreenBackground")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .edgesIgnoringSafeArea(.bottom)
                            .opacity(0.25)
                    }
                }
                .padding(8)
                .onTapGesture {
                    hideKeyboard()
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct BookRequest_Previews: PreviewProvider {
    static var previews: some View {
        BookRequest(book: BookBase.previewInstance)
    }
}
