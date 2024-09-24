//
//  MenuButtons.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/22.
//

import SwiftUI

struct SizeKey: PreferenceKey {
	static let defaultValue: CGSize? = nil
	
	static func reduce(value: inout CGSize?, nextValue: () -> CGSize?) {
		value = value ?? nextValue()
	}
}




struct MenuButtons: View {
	@State private var offset: CGSize = .zero
	@State private var viewSize: CGSize = .zero
	@State private var containerWidth: CGFloat = 0 // 用来存储父视图的宽度
	@EnvironmentObject var manager:peacock
	var body: some View {
		
		HStack{
			// "list.dash"
			
			Button{
				withAnimation(.bouncy(duration: 0.3, extraBounce: 0.2)){
					
					manager.showMenu.toggle()
				}
				
			}label: {
				Image(systemName: manager.showMenu ? "chevron.right.circle" : "chevron.left.circle")
					.frame(width: 40, height: 40)
					.clipShape(Circle())
					.shadow(color: Color("buttonShadow"), radius: 3, x: 0, y: 3)
					.padding(.vertical, 5)
					.symbolVariant(manager.showMenu ? .slash : .none)
					.contentTransition(.symbolEffect(.replace))
			}
			
			ForEach(Page.allCases , id: \.self){item in
				Button{
					withAnimation{
						manager.page = item
						manager.showMenu.toggle()
					}
				}label: {
					Image(systemName: item.rawValue)
						.frame(width: 35, height: 35)
						.background( .gray.opacity(manager.page == item ? 0.3 : 0.1))
						.clipShape(Circle())
						.shadow(color: Color("buttonShadow"), radius: 3, x: 0, y: 3)
						.padding(.leading, item != Page.allCases.first ? 20 : 0)
						.padding(.trailing, item == Page.allCases.last ? 30 : 0)
						.padding(.vertical, 5)
						
				}
			}
			
		}
		
		.background(.ultraThinMaterial)
		.clipShape(UnevenRoundedRectangle(topLeadingRadius: 15, bottomLeadingRadius: 15))
		.offset(x: manager.showMenu ? offset.width : viewSize.width - 36)
		.offset(offset)
		.background(
			
			GeometryReader{ proxy in
				Color.clear.preference(key: SizeKey.self, value: proxy.size)
			}
		)
	
		.onPreferenceChange(SizeKey.self) { value in
			if let size = value{
				self.viewSize = size
			}
			
		}
		
		
	}
}


#Preview {
	MenuButtons()
		.environmentObject(peacock.shared)
}
