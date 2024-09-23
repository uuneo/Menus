//
//  HomeView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/13.
//

import Foundation
import SwiftUI
import Combine
import Defaults


let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
let statusBarHeight = windowScene?.statusBarManager?.statusBarFrame.height ?? 0


struct HomeView: View {
	@EnvironmentObject var manager:peacock
	@Namespace var NewHomeName
	@State var showDetail:Bool = false
	
	@State private var showMenu:Bool = false
	
	
	
	var body: some View {
		NavigationStack{
			ZStack(alignment: .top){
				
				
				ScrollView(.vertical, showsIndicators: false) {
					
					HStack(alignment: .bottom){
						HomeVipCards(Namespace: NewHomeName)
					}
					.frame(height: UIScreen.main.bounds.height * 0.55 - 10)
					
					
					HStack(alignment: .top){
						HomeItemsView(NewHomeName: NewHomeName, showDetail: $showDetail)
					}
					.frame(height: UIScreen.main.bounds.height * 0.45 - 10)
					
					
				}
				.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
				
				
				
				
				itemsView(show: $showDetail,detailName: NewHomeName)
					.background(.ultraThinMaterial)
					.opacity(showDetail ? 1 : 0)
					.offset(y: showDetail ? 0 : 500)
					.onChange(of: showDetail) { oldValue, newValue in
						if newValue {
							withAnimation {
								manager.showMenu = false
							}
							
						}
					}
				
			}
			
		}
		
		
	}
	
	
}





#Preview {
	
	NavigationStack{
		HomeView()
			.environmentObject(peacock.shared)
	}
	
}

