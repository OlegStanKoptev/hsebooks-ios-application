//
//  AdSection.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 12.03.2021.
//

import SwiftUI

struct AdSection: View {
    var images: [Image]
    @State private var currentIndex: Int = 0
    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    private let height: CGFloat = 128
    
    var body: some View {
        VStack {
            TabView(selection: $currentIndex) {
                ForEach(0..<images.count) { index in
                    AdImage(image: images[index])
                }
            }
            .frame(height: 128)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            AdIndexator(currentIndex: $currentIndex, overallAmount: images.count)
        }
        .onReceive(timer) { _ in
            withAnimation {
                currentIndex = (currentIndex + 1) % images.count
            }
        }
    }
}

// Отформатированное рекламное изображение
struct AdImage: View {
    var image: Image
    var body: some View {
        GeometryReader { geo in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: geo.size.width, height: 128)
                .clipped()
        }
    }
}

// Индексатор для рекламного блока
struct AdIndexator: View {
    @Binding var currentIndex: Int
    var overallAmount: Int
    var body: some View {
        HStack {
            ForEach(0..<overallAmount) { index in
                Circle()
                    .fill(
                        index == currentIndex ? Color("SecondColor") :
                            Color(.systemGray5)
                    )
                    .frame(width: 8, height: 8)
            }
        }
    }
}

struct AdSection_Previews: PreviewProvider {
    static let images: [Image] = [
        Image("Ad1"),
        Image("Ad2"),
        Image("Ad3"),
        Image("Ad4")
    ]
    static var previews: some View {
        Group {
            AdSection(images: images)
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
