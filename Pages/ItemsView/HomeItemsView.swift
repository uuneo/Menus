//
//  HomeItemsView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/13.
//


import Defaults
import SwiftUI

struct HomeItemsView: View {
	
	@State var showContent = false
	@State var showMenu = false
	
	var NewHomeName:Namespace.ID
	@Binding var showDetail:Bool
	
	@Default(.Categorys) var items
	@Default(.homeItemsTitle) var title
	@Default(.homeItemsSubTitle) var subTitle
	
	var body: some View {
		
		VStack {
			HStack {
				VStack(alignment: .leading) {
					Text(title)
						.font(.title)
						.fontWeight(.heavy)
					
					Text(subTitle)
						.foregroundColor(.gray)
				}
				Spacer()
				
			}
			.padding(.leading, 30.0)
			
			
			ScrollViewReader { proxy in
				ScrollView(.horizontal, showsIndicators: false) {
					HStack {
						
						scallBtn(proxy: proxy, isHead: true)
						
						
						ForEach($items) { item in
							Button(action: {
								withAnimation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.8)){
									peacock.shared.selectedItem = item.wrappedValue
									self.showDetail.toggle()
								}
								
							}) {
								
								if ISPAD{
									categoryCardView(item: item, NewHomeName: NewHomeName, show: showDetail)
									
								}else{
									GeometryReader { geometry in
										HStack{
											categoryCardView(item: item, NewHomeName: NewHomeName, show: showDetail)
										}
										.rotation3DEffect(Angle(degrees: Double(geometry.frame(in: .global).minX - 40) / -40), axis: (x: 0, y: 10, z: 0))
									}.frame(width: 260, height: 350)
								}
								
								
								
							}
							.padding(.horizontal, 10)
							.id(item.id)
						}
						
						scallBtn(proxy: proxy)
					}
					.padding(.trailing, 30)
					.padding(.leading, 10)
				}
			}
			
			
			
			
		}
		
		
		
		
	}
}

struct categoryCardView: View {
	@Binding var item: CategoryData
	var NewHomeName:Namespace.ID
	var show:Bool
	
	var body: some View {
		ZStack{
			Color(from:  item.color)
				.matchedGeometryEffect(id: "\(item.id)-background", in: NewHomeName,properties: [.position,.size,.frame], isSource: !show)
			
			VStack(alignment: .leading) {
				VStack(alignment: .leading){
					Text(item.title)
						.font(.title)
						.fontWeight(.bold)
					
						.lineLimit(4)
					Text(item.subTitle)
					
					
				}
				.foregroundColor(.white)
				.padding(30)
				.matchedGeometryEffect(id: "\(item.id)-title", in: NewHomeName,properties: [.position,.size,.frame], isSource: !show)
				
				Spacer()
				
				
				
				AsyncImageView(imageUrl: item.image)
				
					.aspectRatio(contentMode: .fit)
					.frame(width: 246, height: 170)
					.matchedGeometryEffect(id: "\(item.id)-image", in: NewHomeName,properties: [.position,.size,.frame], isSource: !show)
			}
			
		}
		.cornerRadius(30)
		.shadow(color: Color(from: item.color).opacity(0.5), radius: 20, x: 0, y: 20)
		.padding()
		.padding(.bottom)
		
		
		
	}
}

#Preview {
	HomeItemsView(NewHomeName: Namespace().wrappedValue, showDetail: .constant(false))
}
