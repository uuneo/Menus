//
//  shadow+.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/19.
//

import Foundation
import SwiftUI

// 创建自定义的 ViewModifier
struct MaterialShadowModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme

    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    // 模拟阴影效果
                    RoundedRectangle(cornerRadius: 10)
                        .fill(colorScheme == .dark ? Color.black.opacity(0.7) : Color.black.opacity(0.2))
                        .offset(x: 10, y: 10)
                        .blur(radius: 10)

                    RoundedRectangle(cornerRadius: 10)
                        .fill(colorScheme == .dark ? Color.white.opacity(0.2) : Color.white.opacity(0.7))
                        .offset(x: -10, y: -10)
                        .blur(radius: 10)
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 10)) // 保持圆角一致
    }
}

// 为 View 扩展一个自定义 modifier
extension View {
    func materialShadow() -> some View {
        self.modifier(MaterialShadowModifier())
    }
}
