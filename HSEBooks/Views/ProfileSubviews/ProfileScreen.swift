//
//  ProfileScreen.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 15.03.2021.
//

import SwiftUI

struct ProfileScreen: View {
    var logOutAction: () -> Void
    var body: some View {
        ScrollView(.vertical)  {
            ProfileMenu() {
                logOutAction()
            }
        }
    }
}



struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen() {}
            .accentColor(Color("Orange"))
    }
}
