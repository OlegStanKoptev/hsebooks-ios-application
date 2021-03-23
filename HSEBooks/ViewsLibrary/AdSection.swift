//
//  AdSection.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 12.03.2021.
//

import SwiftUI

struct AdSection: View {
    var images: [Image]?
    var colors: [Color]?
    @State private var currentIndex: Int = 0
    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    private let height: CGFloat = 128
    private var count: Int {
        return images?.count ?? colors?.count ?? 0
    }
    var body: some View {
        VStack {
            TabView(selection: $currentIndex) {
                Group {
                    if let images = images {
                        ForEach(0..<images.count) { index in
                            GeometryReader { geo in
                                images[index]
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: geo.size.width, height: height)
                                    .clipped()
                            }
                        }
                    } else if let colors = colors {
                        ForEach(0..<colors.count) { index in
                            colors[index]
                        }
                    }
                }
            }
            .frame(height: height)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            HStack {
                ForEach(0..<count) { index in
                    Circle()
                        .fill(index == currentIndex ? Color("AccentColor") : Color(.systemGray5))
                        .frame(width: 8, height: 8)
                }
            }
        }
        .onReceive(timer) { _ in
            withAnimation {
                currentIndex = (currentIndex + 1) % count
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
    static let colors: [Color] = [
        Color.blue,
        Color.purple,
        Color.red,
        Color.orange,
        Color.yellow,
        Color.green
    ]
    static var previews: some View {
        Group {
            AdSection(images: images)
            AdSection(colors: colors)
        }
            .previewLayout(.sizeThatFits)
    }
}
