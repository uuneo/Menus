//
//  MenuPriceView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/29.
//

import SwiftUI


let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
let statusBarHeight = windowScene?.statusBarManager?.statusBarFrame.height ?? 0

struct MenuPriceView: View {
	@Namespace var NewHomeName
	
	@EnvironmentObject var manager:peacock
	
	var body: some View {
		NavigationStack{
			ZStack(alignment: .top){
				
				
				ScrollView(.vertical, showsIndicators: false) {
					
					HStack(alignment: .bottom){
						HomeVipCards(Namespace: NewHomeName)
							.padding(.top, 30)
					}
					.frame(height: UIScreen.main.bounds.height * 0.5)
					
					
					
					HStack(alignment: .top){
						HomeItemsView(NewHomeName: NewHomeName)
					}
					.frame(height: UIScreen.main.bounds.height * 0.5)
					
					
				}
				.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
				
				
				
				
				if manager.selectedItem != nil{
					itemsView(detailName: NewHomeName)
						.background(.ultraThinMaterial)
				}
				
			
			
				
				
			}
			.background( Color.background)
			
		}
		
		
	}
	
}

#Preview {
    MenuPriceView()
}
