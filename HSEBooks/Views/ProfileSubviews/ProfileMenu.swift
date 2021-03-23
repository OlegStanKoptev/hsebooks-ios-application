//
//  ProfileMenu.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 22.03.2021.
//

import SwiftUI

struct ProfileMenu: View {
    @State var loadOnlyWithWifi: Bool = false
    var logOutAction: () -> Void
    var body: some View {
        ScrollView(.vertical)  {
            VStack(spacing: 8) {
                Section {
                    LinkItem(title: "Profile Information", systemImage: "key", destination: Text("Profile"))
                    LinkItem(title: "Favorites", systemImage: "heart", destination: Favorites())
                    LinkItem(title: "Notifications", systemImage: "bell", destination: Text("Notifications"))
                    LinkItem(title: "My Reviews", systemImage: "ellipsis.bubble", destination: Text("Reviews"))
                }
                
                Section {
                    LinkItem(title: "My Books", systemImage: "book", destination: MyBooks())
                }

                Section {
                    LinkItem(title: "My Requests", systemImage: "bubble.left.and.bubble.right", destination: Requests(currentPage: .outcoming))
                }

                Section(title: "Preferences", systemImage: "gearshape") {
                    ChooserItem(title: "Language", currentValue: "English")
                    SwitcherItem(title: "Load images only through Wi-Fi", isOn: $loadOnlyWithWifi)
                    LinkItem(title: "Help", destination: Text("Help"))
                }

                Section {
                    ButtonItem(title: "Log Out", systemImage: "escape") {
                        logOutAction()
                    }
                }
            }
        }
    }
    
    struct Section<Content: View>: View {
        var title: String?
        var systemImage: String?
        var content: Content
        init(title: String? = nil, systemImage: String? = nil, @ViewBuilder content: () -> Content) {
            self.title = title
            self.systemImage = systemImage
            self.content = content()
        }
        var body: some View {
            VStack(spacing: 0) {
                if let title = title {
                    HStack {
                        if let systemImage = systemImage {
                            Image(systemName: systemImage)
                                .foregroundColor(.gray)
                                .font(.system(size: 20))
                                .frame(width: UIFont.preferredFont(forTextStyle: .body).pointSize + 6)
                        }
                        Text(title)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .padding(.top, 2)
                }
                
                content
            }
            .background(
                Color.white
                    .shadow(
                        color: Color.black.opacity(0.2),
                        radius: 2,
                        y: 3.0)
            )
            .padding(.bottom, 4)
        }
    }
    
    struct MenuItemBase<Content: View>: View {
        var title: String
        var systemImage: String?
        var content: Content
        
        init(title: String, systemImage: String?, @ViewBuilder content: () -> Content) {
            self.title = title
            self.systemImage = systemImage
            self.content = content()
        }
        
        var body: some View {
            HStack {
                if let systemImage = systemImage {
                    Image(systemName: systemImage)
                        .foregroundColor(.gray)
                        .font(.system(size: 20))
                        .frame(width: UIFont.preferredFont(forTextStyle: .body).pointSize + 14)
                }
                Text(title)
                    .foregroundColor(.primary)
                
                Spacer(minLength: 0)
                
                content
            }
        }
    }
    
    struct LinkItem<Destination: View>: View {
        var title: String = "Item"
        var systemImage: String?
        var destination: Destination
        var body: some View {
            NavigationLink(
                destination: destination,
                label: {
                    MenuItemBase(title: title, systemImage: systemImage) {
                        Image(systemName: "chevron.forward")
                    }
                }
            )
            .profileMenuItemStyle()
        }
    }
    
    struct ChooserItem: View {
        var title: String = "Item"
        var currentValue: String?
        var systemImage: String?
        var body: some View {
            MenuItemBase(title: title, systemImage: systemImage) {
                if let value = currentValue {
                    Text(value)
                }
                Image(systemName: "chevron.forward")
            }
            .profileMenuItemStyle()
        }
    }
    
    struct SwitcherItem: View {
        var title: String = "Item"
        var systemImage: String?
        @Binding var isOn: Bool
        var body: some View {
            MenuItemBase(title: title, systemImage: systemImage) {
                Toggle("", isOn: $isOn)
                    .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                    .frame(width: 60, alignment: .trailing)
            }
            .profileMenuItemStyle()
        }
    }
    
    struct ButtonItem: View {
        var title: String = "Item"
        var systemImage: String?
        var action: () -> Void
        var body: some View {
            Button(action: { action() }, label: {
                HStack(spacing: 4) {
                    HStack {
                        if let systemImage = systemImage {
                            Image(systemName: systemImage)
                        }
                        Text(title)
                        Spacer(minLength: 0)
                    }
                }
                .foregroundColor(.accentColor)
                .profileMenuItemStyle()
            })
        }
    }
}

struct ProfileMenuItemStyle: ViewModifier {
    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            content
                .padding(.horizontal, 16)
                .frame(height: UIFont.preferredFont(forTextStyle: .body).pointSize + 26)
                .background(Color.gray.opacity(0.075))
                .foregroundColor(.gray)
            Rectangle()
                .fill(Color(.separator))
                .frame(height: 2)
        }
    }
}

extension View {
    func profileMenuItemStyle() -> some View {
        self.modifier(ProfileMenuItemStyle())
    }
}


struct NewProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileMenu() {}
            .accentColor(Color("Orange"))
    }
}
