//
//  BookListSelector.swift
//  BookExchange
//
//  Created by Oleg Koptev on 25.01.2021.
//

import SwiftUI

struct BookListSelector: View {
    @ObservedObject var viewRouter: BookListViewRouter = BookListViewRouter()
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 18) {
                Color.clear.frame(width: 0)
                ForEach(BookListPage.allCases, id: \.rawValue) { page in
                    Text(page.rawValue)
                        .foregroundColor(viewRouter.currentPage == page ? .orange : .white)
                        .onTapGesture {
                            viewRouter.currentPage = page
                        }
                }
                Spacer(minLength: 0)
            }
            .font(.system(size: 15))
            .textCase(.uppercase)
            .frame(height: Constants.navBarChinHeight)
            .foregroundColor(.white)
        }
        .background(Color("Accent"))
    }
}
struct BookListSelector_Previews: PreviewProvider {
    static var previews: some View {
        BookListSelector()
    }
}
