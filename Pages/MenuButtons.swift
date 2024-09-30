//
//  MenuButtons.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/22.
//

import SwiftUI
import Defaults




struct MenuButtons: View {
	@State private var containerWidth: CGFloat = 0 // 用来存储父视图的宽度
	@EnvironmentObject var manager:peacock
	
	let openSetting = SettingTipView()
	var body: some View {
		
		HStack{
			// "list.dash"
			
			Button{
				withAnimation(.bouncy(duration: 0.3, extraBounce: 0.2)){
					
					manager.page =	manager.page == .home ? .setting  : .home
				}
				
			}label: {
				
				Image(systemName:  manager.page == .home ?   "gear.circle" : "chevron.left.circle")
					.frame(width: 40, height: 40)
					.clipShape(Circle())
					.shadow(color: Color("buttonShadow"), radius: 3, x: 0, y: 3)
					.padding(.vertical, 5)
					.symbolVariant( manager.page == .home ? .slash : .none)
					.contentTransition(.symbolEffect(.replace))
					.accentColor(.black)
			}
		
			
		}
		
		.background(.ultraThinMaterial)
		.clipShape(UnevenRoundedRectangle(topLeadingRadius: 15, bottomLeadingRadius: 15))
		
		
		
	}
}


#Preview {
	ContentView()
		.environmentObject(peacock.shared)
}
