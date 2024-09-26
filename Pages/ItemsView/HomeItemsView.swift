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
	
	@EnvironmentObject var manager:peacock
	
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
									if manager.showMenu{
										manager.showMenu = false
									}
									peacock.shared.selectedItem = item.wrappedValue
									self.showDetail.toggle()
									
									
								}
								DispatchQueue.main.asyncAfter(deadline: .now() + 1){
									DiscountTipView.startTipHasDisplayed = true
								}
							}) {
								
								if ISPAD{
									categoryCardView(item: item, NewHomeName: NewHomeName, show: showDetail)
										.fixedSize(horizontal: true, vertical:  false)
										.zIndex(100)
								}else{
									GeometryReader { geometry in
										HStack{
											categoryCardView(item: item, NewHomeName: NewHomeName, show: showDetail)
												.fixedSize(horizontal: true, vertical: false)
										}
										.rotation3DEffect(Angle(degrees: Double(geometry.frame(in: .global).minX - 40) / -40), axis: (x: 0, y: 10, z: 0))
									}.frame(width: 260)
								}
								
								
								
							}
							.padding(.horizontal, 20)
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
				
			
			VStack(alignment: .leading) {
				VStack(alignment: .leading){
					Text(item.title)
						.font(.title)
						.fontWeight(.bold)
						.minimumScaleFactor(0.8)
						.lineLimit(1)
					
					Text(item.subTitle)
						.minimumScaleFactor(0.6)
						.lineLimit(1)
					
					
				}
				.foregroundColor(.white)
				.padding(30)
				
				.matchedGeometryEffect(id: "\(item.id)-title", in: NewHomeName,properties: [.position,.size,.frame], isSource: !show)
				
				Spacer()
				
				
				
				AsyncImageView(imageUrl: item.image)
				
					.aspectRatio(contentMode: .fit)
					.frame(width: 260)
					.matchedGeometryEffect(id: "\(item.id)-image", in: NewHomeName,properties: [.position,.size,.frame], isSource: !show)
			}
			
		}
		
		.cornerRadius(30)
		.shadow(color: Color.shadow2, radius: 1, x: -1, y: -1)
		.shadow(color: Color.shadow1, radius: 1, x: 1, y: 1)
		.shadow(color: Color.shadow1, radius: 10, x: 10, y: 10)
		.shadow(color: Color(from:item.color), radius: 3, x: 3, y: 3)
		.padding()
		.frame(width: 260)
		.matchedGeometryEffect(id: "\(item.id)-background", in: NewHomeName,properties: [.position,.size,.frame], isSource: !show)
		
		
		
	}
}

#Preview {
	@Previewable @State var showDetail:Bool = false
	HomeItemsView(NewHomeName: Namespace().wrappedValue, showDetail: $showDetail)
		.environmentObject(peacock.shared)
}
