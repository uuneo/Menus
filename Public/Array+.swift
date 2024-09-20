//
//  VipCardModal.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/4.
//

import Foundation
import Combine
import SwiftUI
import SwiftMessages

struct RawRepresentableArray<Element>: RawRepresentable where Element: Codable {
    var array: [Element]

    // 从原始值（例如 JSON 字符串）初始化
    init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let decodedArray = try? JSONDecoder().decode([Element].self, from: data) else {
            return nil
        }
        self.array = decodedArray
    }

    // 将数组转换为原始值（例如 JSON 字符串）
    var rawValue: String {
        guard let data = try? JSONEncoder().encode(array),
              let jsonString = String(data: data, encoding: .utf8) else {
            return "[]"
        }
        return jsonString
    }
}


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


extension DemoMessage: MessageViewConvertible {
    func asMessageView() -> DemoMessageView {
        DemoMessageView(message: self)
    }
}


struct DemoMessage: Identifiable,Equatable {
    let title: String
    let body: String
    var id: String { title + body }
}


struct DemoMessageView: View {

    let message: DemoMessage

    var body: some View {
        HStack(alignment: .center) {
            Text(message.title).font(.system(size: 20, weight: .bold))
            Text(message.body)
        }
        .foregroundStyle(Color.accent1)
        .multilineTextAlignment(.leading)
        .padding(30)
        // This makes the message width greedy
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        // This makes a tab-style view where the bottom corners are rounded and
        // the view's background extends to the top edge.
        .mask(
            UnevenRoundedRectangle(bottomLeadingRadius: 15, bottomTrailingRadius: 15)
            // This causes the background to extend into the safe area to the screen edge.
            .edgesIgnoringSafeArea(.top)
        )
    }
}
