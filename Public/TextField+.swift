//
//  VipCardModal.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/4.
//

import Foundation
import SwiftUI



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


struct TextFieldModifier: ViewModifier {
    var icon: String
    var iconColor: Color
    var title: String = ""

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
			
			if title != "" {
				Text(title)
					.font(.headline)
					.foregroundColor(.primary)
					.lineLimit(1) // 保证标题在一行内显示
					.padding(.leading, 8) // 调整标题和图标之间的间距
				
			}
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
	func customField(icon: String,iconColor:Color = Color.secondary,title:String = "") -> some View {
		self.modifier(TextFieldModifier( icon: icon,iconColor: iconColor,title: title))
	}
}
