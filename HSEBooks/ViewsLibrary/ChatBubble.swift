//
//  ChatBubble.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 24.03.2021.
//

import SwiftUI

struct ChatBubble: View {
    enum BubbleType {
        case incoming, outcoming, first
    }
    
    var text: String = "Some text"
    var date: String = "01.01.01"
    var image: Image?
    var bubbleType: BubbleType = .first
    
    private let grayColor: Color = Color(hue: 0, saturation: 0, brightness: 0.925)
    private let darkGrayColor: Color = Color(hue: 0, saturation: 0, brightness: 0.85)
    private let lightGrayColor: Color = Color(hue: 0, saturation: 0, brightness: 0.95)
    private let cornerRadius: CGFloat = 12
    private let triangleDimension: CGFloat = 16
    
    var body: some View {
        Group {
            switch bubbleType {
            case .first:
                
                HStack {
                    Spacer(minLength: 0)
                    Text(text)
                    Spacer(minLength: 0)
                }
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(lightGrayColor)
                )
                
            case .incoming:
                HStack(alignment: .top, spacing: -4) {
                    Circle()
                        .fill(darkGrayColor)
                        .overlay(
                            Group {
                                if let image = image {
                                    image
                                        .resizable()
                                } else {
                                    Image(systemName: "person.fill")
                                        .foregroundColor(.white)
                                        .font(.system(size: 18))
                                }
                            }
                        )
                        .frame(width: 28, height: 28, alignment: .center)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(date)
                            .font(.caption)
                        Text(text)
                    }
                    .padding(10)
                    .padding(.leading, triangleDimension)
                    .background(
                        HStack(spacing: 0) {
                            Path { path in
                                let height: CGFloat = triangleDimension
                                let width: CGFloat = height
                                
                                path.move(to: CGPoint(x: width, y: 0))
                                path.addLine(to: CGPoint(x: 0, y: 0))
                                path.addLine(to: CGPoint(x: width, y: height))
                                path.addLine(to: CGPoint(x: width, y: 0))
                            }
                            .fill(grayColor)
                            .frame(width: triangleDimension)
                            
                            Rectangle()
                                .fill(grayColor)
                                .cornerRadius(cornerRadius, corners: [.topRight, .bottomLeft, .bottomRight])
                        }
                    )
                    
                    Spacer(minLength: 40)
                }
                
            case .outcoming:
                HStack(alignment: .top, spacing: -4) {
                    Spacer(minLength: 40)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(date)
                            .font(.caption)
                        Text(text)
                    }
                    .foregroundColor(.white)
                    .padding(10)
                    .padding(.trailing, triangleDimension)
                    .background(
                        HStack(spacing: 0) {
                            Rectangle()
                                .fill(Color("SecondColor"))
                                .cornerRadius(cornerRadius, corners: [.topLeft, .bottomRight, .bottomLeft])
                            
                            Path { path in
                                let height: CGFloat = triangleDimension
                                let width: CGFloat = height
                                
                                path.move(to: CGPoint(x: 0, y: 0))
                                path.addLine(to: CGPoint(x: width, y: 0))
                                path.addLine(to: CGPoint(x: 0, y: height))
                                path.addLine(to: CGPoint(x: 0, y: 0))
                            }
                            .fill(Color("SecondColor"))
                            .frame(width: triangleDimension)
                        }
                    )
                    
                    Circle()
                        .fill(Color("SecondColor"))
                        .overlay(
                            Group {
                                if let image = image {
                                    image
                                        .resizable()
                                } else {
                                    Image(systemName: "person.fill")
                                        .foregroundColor(.white)
                                        .font(.system(size: 18))
                                }
                            }
                        )
                        .frame(width: 28, height: 28, alignment: .center)
                }
            }
        }
    }
}

struct ChatBubble_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ChatBubble(bubbleType: .first)
            ChatBubble(bubbleType: .incoming)
            ChatBubble(bubbleType: .outcoming)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
