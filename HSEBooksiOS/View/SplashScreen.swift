//
//  SplashScreen.swift
//  HSEBooksiOS
//
//  Created by Oleg Koptev on 23.05.2021.
//

import SwiftUI

struct SplashScreen: View {
    var token: String = ""
    @ObservedObject var appContext = AppContext.shared
    @StateObject private var viewModel = ViewModel()
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 32) {
                Spacer()
                
                Text("BOOK EXCHANGE")
                    .font(.title)
                    .foregroundColor(.white)
                
                Spacer()
                Spacer()
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                
                Spacer()
            }
            Spacer()
        }
        .background(
            Color.tertiaryColor
                .edgesIgnoringSafeArea(.all)
        )
        .onAppear {
            viewModel.fetch(with: token, context: appContext)
        }
    }
}

extension SplashScreen {
    class ViewModel: ObservableObject {
        @Published var viewState: ViewState = .none
        
        func fetch(with token: String, context: AppContext) {
            guard !context.isPreview else { return }
            guard !token.isEmpty else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    context.splashScreenPresented = false
                }
                return
            }
            AppContext.shared.fullUpdate(with: token) {
                context.splashScreenPresented = false
            }
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen(appContext: .preview)
    }
}
