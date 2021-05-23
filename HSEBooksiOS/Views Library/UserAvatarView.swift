//
//  UserAvatarView.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 22.05.2021.
//

import SwiftUI

struct UserAvatarView: View {
    var id: Int?
    var placeholderColor: Color = .white
    var placeholderBackground: Color = .tertiaryColor
    
    @ObservedObject var appContext = AppContext.shared
    @State var image: Image?
    private let placeholder = Image(systemName: "person.circle.fill")
    
    private func fetch() {
        guard let id = id else { return }
        ImageStorage.shared.getAvatar(for: id, with: appContext) { photo in
            image = Image(uiImage: UIImage(data: Data(base64Encoded: photo.image)!)!)
        }
    }
    
    var body: some View {
        Group {
            if let image = image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                placeholder
                    .resizable()
                    .foregroundColor(placeholderBackground)
                    .background(
                        placeholderColor
                            .clipShape(Circle())
                            .padding(2)
                    )
                    .aspectRatio(contentMode: .fit)
            }
        }
        .clipShape(Circle())
        .onAppear { fetch() }
    }
}

struct UserAvatarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            UserAvatarView(image: Image(uiImage: UIImage(data: Data(base64Encoded: Avatar.previewInstance.image)!)!))
                .frame(width: 150, height: 150)
            
            UserAvatarView()
                .frame(width: 150, height: 150)
            
            UserAvatarView(image: Image(uiImage: UIImage(data: Data(base64Encoded: Avatar.previewInstance.image)!)!))
                .frame(width: 300, height: 150)
            
            UserAvatarView()
                .frame(width: 300, height: 150)
            
            UserAvatarView(image: Image(uiImage: UIImage(data: Data(base64Encoded: Avatar.previewInstance.image)!)!))
                .frame(width: 150, height: 200)

            UserAvatarView()
                .frame(width: 150, height: 200)
        }
//            .previewLayout(.sizeThatFits)
    }
}
