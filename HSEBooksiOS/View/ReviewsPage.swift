//
//  ReviewsPage.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 05.05.2021.
//

import SwiftUI

struct ReviewsPage: View {
    var body: some View {
        List {
            ForEach(0..<15) { item in
                Text("Apple \(item)")
            }
        }
        .navigationTitle("Reviews")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ReviewsPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ReviewsPage()
        }
    }
}
