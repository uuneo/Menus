//
//  PhotoPreView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/10/3.
//
import SwiftUI

struct PhotoPreView: View{
	var image:String
	@Binding var show:Bool
	var body:some View{
		VStack{
			RoundedRectangle(cornerRadius: 1)
				.fill(Color.clear)
				.background(.ultraThinMaterial)
				.overlay {
					ZStack{
						AsyncImageView(imageUrl: image)
							.aspectRatio(contentMode: .fit)
						
						VStack{
							HStack{
								Image(systemName: "xmark.seal")
									.padding(10)
									.background(.ultraThinMaterial,in: .rect(cornerRadius: 30))
									.onTapGesture {
										self.show = false
									}
									.offset(y: 50)
								Spacer()
							}
							Spacer()
						}
					}
						
				}
			
		}
	}
}
