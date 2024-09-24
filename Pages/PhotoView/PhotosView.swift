//
//  PhotosView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/22.
//

import SwiftUI
import Defaults

struct PhotosView: View {
	@Default(.menusName) var itemName
	@Default(.menusSubName) var subName
	@Default(.menusFooter) var footerName
	@Default(.menusImage) var menusImage
	
	var body: some View {
		ZStack{
			
			
			AsyncImageView(imageUrl: menusImage)
				.scaledToFill()
				.frame(width: UIScreen.main.bounds.width, height:  UIScreen.main.bounds.height)
				
				
			
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
					}
					
					
					Divider()
		
					
				}
				.padding(30)
				
				Spacer()
				HStack{
					Spacer()
					Text(footerName)
						.font(.system(size: 40))
						.bold()
						.padding()
						.foregroundStyle(.orange)
					
					
					
					Spacer()
				}
				.blendMode(.difference)
				.offset(y: -100)
			}
			
			
			
			
		}
		.frame(width: UIScreen.main.bounds.width, height:  UIScreen.main.bounds.height)
		.ignoresSafeArea()
		
	}
}

#Preview {
	PhotosView()
}
