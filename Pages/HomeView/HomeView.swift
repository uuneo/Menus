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
			
			HomeMenuView()
				.offset(y: 30)
			
			
			
			
		}
		.frame(width: UIScreen.main.bounds.width, height:  UIScreen.main.bounds.height)
		.ignoresSafeArea()
		
	}
	
}





#Preview {
	
	NavigationStack{
		HomeView()
			.environmentObject(peacock.shared)
	}
	
}

