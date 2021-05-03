//
//  ProfilePage.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 29.04.2021.
//

import SwiftUI


struct ProfilePage: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Profile Page")
            }
            .navigationTitle("Profile")
            .navigationBarHidden(true)
        }
    }
}

struct ProfilePage_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePage()
    }
}
