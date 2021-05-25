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
            VStack(spacing: 0) {
                Color.tertiaryColor
                
                Text("BOOK EXCHANGE")
                    .font(.title)
                    .foregroundColor(.white)
                
                Color.tertiaryColor
                Color.tertiaryColor
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                
                Color.tertiaryColor
                    .frame(height: UIFont.preferredFont(forTextStyle: .caption1).pointSize)
                    .zIndex(1)
                
                Group {
                    if !viewModel.connected {
                        Text("Connecting to \(RequestService.shared.serverUrl.absoluteString)...")
                    } else {
                        Text("Connected to \(RequestService.shared.serverUrl.absoluteString)!")
                    }
                }
                .transition(.asymmetric(insertion: .move(edge: .top), removal: .move(edge: .bottom)))
                .font(.caption)
                .foregroundColor(.white)
                
                Color.tertiaryColor
                    .zIndex(1)
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
        @Published var connected: Bool = false
        
        func fetch(with token: String, context: AppContext) {
            guard !context.isPreview else { return }
            guard !token.isEmpty else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    context.splashScreenPresented = false
                }
                return
            }
            AppContext.shared.fullUpdate(with: token) { [weak self] in
                withAnimation { self?.connected = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    context.splashScreenPresented = false
                }
            }
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen(appContext: .preview)
    }
}
