//
//  VipCardModal.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/4.
//

import Foundation
import Combine
import SwiftUI


extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }
    
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}


struct TextFieldModifier: ViewModifier {
    var icon: String
    var iconColor:Color
    func body(content: Content) -> some View {
        content
            .overlay(
                HStack {
                    Image(systemName: icon)
                        .frame(width: 36, height: 36)
                        .background(.thinMaterial)
                        .cornerRadius(14)
                        .modifier(OutlineOverlay(cornerRadius: 14))
                        .offset(x: -46)
                        .foregroundStyle(iconColor)
                        .accessibility(hidden: true)
                        .animation(Animation.bouncy(duration: 1, extraBounce: 0.5), value: iconColor)
                    Spacer()
                }
            )
            .foregroundStyle(.primary)
            .padding(15)
            .padding(.leading, 40)
            .background(.thinMaterial)
            .cornerRadius(20)
            .modifier(OutlineOverlay(cornerRadius: 20))
    }
}

extension View {
    func customField(icon: String,iconColor:Color = Color.secondary) -> some View {
        
        self.modifier(TextFieldModifier( icon: icon,iconColor: iconColor))
    }
}


struct OutlineOverlay: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    var cornerRadius: CGFloat = 20
    
    func body(content: Content) -> some View {
        content.overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(
                    .linearGradient(
                        colors: [
                            .white.opacity(colorScheme == .dark ? 0.6 : 0.3),
                            .black.opacity(colorScheme == .dark ? 0.3 : 0.1)
                        ],
                        startPoint: .top,
                        endPoint: .bottom)
                )
                .blendMode(.overlay)
        )
    }
}


struct TextImageFieldModifier: ViewModifier {
    var icon: String
    var iconColor: Color
    var title: String

    func body(content: Content) -> some View {
        HStack {
            // 图标
            Image(systemName: icon)
                .frame(width: 36, height: 36)
                .background(.thinMaterial)
                .cornerRadius(14)
                .modifier(OutlineOverlay(cornerRadius: 14))
                .foregroundStyle(iconColor)
                .accessibility(hidden: true)
                .animation(Animation.bouncy(duration: 1, extraBounce: 0.5), value: iconColor)

            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(1) // 保证标题在一行内显示
                .padding(.leading, 8) // 调整标题和图标之间的间距

            // Spacer 用于填充
            Spacer()

            // TextField 内容
            content
                .foregroundStyle(.primary)
                .padding(15)
                .background(.thinMaterial)
                .cornerRadius(20)
                .modifier(OutlineOverlay(cornerRadius: 20))
        }
        .padding(.horizontal)
    }
}


extension View {
    func customTitleField(icon: String,iconColor:Color = Color.secondary,title:String = "") -> some View {
        
        self.modifier(TextImageFieldModifier( icon: icon,iconColor: iconColor,title: title))
    }
}
