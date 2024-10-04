//
//  ContentView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/2.
//

import SwiftUI
import Defaults
import UIKit


struct ContentView: View {
	
	@EnvironmentObject var manager:peacock
	@Default(.firstStart) var firstStart
	
	
	var body: some View {
		
		ZStack(alignment: .top){
			Group{
				switch manager.page{
				case .home:
					MenuPriceView()
				case .setting:
					HomeSettingView()
				}
				
				
			}
			.transition(AnyTransition.opacity.combined(with: .slide))
			
			
			HStack{
				Spacer()
				MenuButtons()
					.onAppear{
						if firstStart{
							manager.showMenu = true
							manager.showCardDetail.toggle()
							
							DispatchQueue.main.asyncAfter(deadline: .now() + 2 ){
								withAnimation {
									manager.showCardDetail.toggle()
								}
								DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
									
									SettingTipView.startTipHasDisplayed = true
								}
								
								
							}
							
							
						}
					}
				
			}
			.zIndex(199)
			.offset(y: 40)
			
			
			
			
		}
	}
	
}







#Preview {
	ContentView()
		.environmentObject(peacock.shared)
}

