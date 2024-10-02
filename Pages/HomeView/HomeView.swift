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


struct HomeView: View {
	@Default(.menusName) var itemName
	@Default(.menusSubName) var subName
	@Default(.menusFooter) var footerName
	@Default(.menusImage) var menusImage
	@EnvironmentObject var manager:peacock
	
	var body: some View {
		ZStack{
			
			
			AsyncImageView(imageUrl: menusImage)
				.scaledToFill()
				.frame(width: UIScreen.main.bounds.width, height:  UIScreen.main.bounds.height)
				.blur(radius: 10)
			
			if ISPAD{
				privateIpadView()
			}else{
				privateIphoneView()
			}
			
			
			
			HomeMenuView()
				.offset(y: 30)
				.zIndex(9999)
			
			
			
			
		}
		.frame(width: UIScreen.main.bounds.width, height:  UIScreen.main.bounds.height)
		.ignoresSafeArea()
		
	}
	
	@ViewBuilder
	func privateIphoneView()-> some View{
		VStack(alignment: .leading){
			HStack{
				VStack(alignment: .leading){
					Text(itemName)
						.font(.title)
						.bold()
						.foregroundStyle(.black)
					
					Text(subName)
						.font(.title3)
						.foregroundStyle(.gray)
				}
				Spacer()
			}
			
			Text(footerName)
				.font(.title3)
				.bold()
				.foregroundStyle(.gray)
			
			Spacer()
		}
		.padding(.leading, 30)
		.padding(.top, 100)
		
	}
	
	@ViewBuilder
	func privateIpadView()-> some View{
		VStack{
			
			VStack{
				HStack{
					Text(itemName)
						.font(.system(size: 35))
						.bold()
						.padding()
						.foregroundStyle(.black)
					
					
					Text(subName)
						.font(.system(size: 25))
						.padding()
						.foregroundStyle(.gray)
					
					
					Spacer()
					Text(footerName)
						.font(.system(size: 30))
						.bold()
						.foregroundStyle(.gray)
						.blendMode(.difference)
				}
				.padding(.horizontal, 80)
				
				
				Divider()
				
				
			}
			.padding(30)
			
			Spacer()
		}
	}
	
}





#Preview {
	
	NavigationStack{
		HomeView()
			.environmentObject(peacock.shared)
	}
	
}

