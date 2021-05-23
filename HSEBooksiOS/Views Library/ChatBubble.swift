//
//  ChatBubble.swift
//  HSEBooks
//
//  Created by Oleg Koptev on 24.03.2021.
//

import SwiftUI

struct ChatBubble: View {
    enum BubbleType {
        case incoming, outcoming
    }
    
    let text: String
    let date: String
    let avatarId: Int?
    let bubbleType: BubbleType
    
    private let grayColor: Color = Color(hue: 0, saturation: 0, brightness: 0.925)
    private let darkGrayColor: Color = Color(hue: 0, saturation: 0, brightness: 0.85)
    private let lightGrayColor: Color = Color(hue: 0, saturation: 0, brightness: 0.95)
    private let cornerRadius: CGFloat = 12
    private let triangleDimension: CGFloat = 16
    
    var body: some View {
        Group {
            switch bubbleType {
            case .incoming:
                HStack(alignment: .top, spacing: -4) {
                    UserAvatarView(id: avatarId, placeholderColor: .black, placeholderBackground: grayColor)
                        .frame(width: 30, height: 30)
                    
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
                                .fill(Color.tertiaryColor)
                                .cornerRadius(cornerRadius, corners: [.topLeft, .bottomRight, .bottomLeft])
                            
                            Path { path in
                                let height: CGFloat = triangleDimension
                                let width: CGFloat = height
                                
                                path.move(to: CGPoint(x: 0, y: 0))
                                path.addLine(to: CGPoint(x: width, y: 0))
                                path.addLine(to: CGPoint(x: 0, y: height))
                                path.addLine(to: CGPoint(x: 0, y: 0))
                            }
                            .fill(Color.tertiaryColor)
                            .frame(width: triangleDimension)
                        }
                    )
                    
                    UserAvatarView(id: avatarId)
                        .frame(width: 30, height: 30)
                }
            }
        }
    }
}

struct ChatBubble_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ChatBubble(text: "Text Message", date: "date", avatarId: nil, bubbleType: .incoming)
            ChatBubble(text: "Text Message", date: "date", avatarId: nil, bubbleType: .outcoming)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
