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

	
	var body: some View {
		
		ZStack(alignment: .top){
			
			switch manager.page {
			case .home:
				HomeView()
					.transition(AnyTransition.opacity.combined(with: .slide))
			case .setting:
				HomeSettingView()
					.transition(AnyTransition.opacity.combined(with: .slide))
			case .photo:
				PhotosView()
					.transition(AnyTransition.opacity.combined(with: .slide))
			}
			
			
			HStack{
				Spacer()
				MenuButtons()
					
				
			}
			.zIndex(99)
			.offset(y: 50)
			
			
			
		}
		
	}
	
}







#Preview {
    ContentView()
		.environmentObject(peacock.shared)
}
  
