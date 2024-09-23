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


struct TextFieldModifier<T: Equatable>: ViewModifier {
    var icon: String
    var iconColor: Color
    var title: String = ""
	@Binding var data:T
	
	func clear(){
		if data is String{
			data = "" as! T
		}else if data is Int{
			data = 0 as! T
		}
	}
	
	// 检查值是否为空
	func isDataEmpty() -> Bool {
		if let stringValue = data as? String {
			return stringValue.isEmpty
		} else if let intValue = data as? Int {
			return intValue == 0
		}
		return true // 默认认为空
	}
	
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
				.overlay {
					HStack{
						Spacer()
						if !isDataEmpty() {
							Button {
								clear()
							} label: {
								Image(systemName: "xmark")
									.foregroundStyle(.secondary)
									.padding(10)
									.background(.ultraThinMaterial)
									.clipShape(Circle())
									.padding(.trailing, 8)
									.contentShape(Circle())
							}
						}
					}
				}
			
        }
        .padding(.horizontal)
    }
}

extension View {
	func customField<T:Equatable>(icon: String,iconColor:Color = Color.secondary,title:String = "", data: Binding<T>) -> some View {
		self.modifier(TextFieldModifier( icon: icon,iconColor: iconColor,title: title,data: data))
	}
}
