//
//  ItemDetailView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/13.
//

import SwiftUI
import ScalingHeaderScrollView
import Defaults
import TipKit


struct itemsView: View {
	
	@EnvironmentObject var manager:peacock
    var detailName:Namespace.ID
    
    @State private var progress:CGFloat = 0
    @State private var isScrolling:Bool = false
    @Namespace var ItemDataSpace
    
    @State private var showCardDetail:Bool = false
    
    var columns = Array(repeating: GridItem(.flexible(),spacing: 30), count: 3)
    
    @Default(.Subcategorys) var subcategoryItems
    
    @Default(.Items) var items
    
    var selectItems:[SubCategoryData]{
        return subcategoryItems.filter({$0.categoryId  == manager.selectedItem?.id})
    }
	
	let discountTip = DiscountTipView()
    
    var body: some View {
        
        ScalingHeaderScrollView {
            ZStack {
				if let data = manager.selectedItem{
					Color(from: data.color)
						.edgesIgnoringSafeArea(.all)
				}
             
                   
                
                if ISPAD{
                    ipadHeader()
                } else{
                    iphoneHeader()
                }
                
                
            }
			.matchedGeometryEffect(id: "\(manager.selectedItem?.id ?? "")-background", in: detailName,properties: [.position,.size,.frame], isSource: manager.selectedItem == nil)
        } content: {
            ZStack{
                
                LazyVStack{
                    
                    ForEach(selectItems, id: \.id){item in
                        if items.filter({$0.subcategoryId == item.id}).count > 0{
                            itemView(subcategory: item)
                        }
                    }
                    
                    if selectItems.count > 1{
                        Spacer(minLength: 200)
                    }
                    
                }
                
                
            }
            
            
            
        }
        .initialSnapPosition(initialSnapPosition: 1)
        .allowsHeaderGrowth()
        .height(min: 100.0, max: 250.0)
        .collapseProgress( $progress)
        .setHeaderSnapMode(.immediately)
        .hideScrollIndicators()
        .scrollToTop(resetScroll: $isScrolling)
        .background(
            Color.background
        )
        .ignoresSafeArea()
		
        
        
        
        
    }
    
    private func ipadHeader() -> some View{
        ZStack{
            HStack{
                VStack{
                    Spacer()
                    Button{
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.8)) {
							manager.selectedItem = nil
                        }
                        
                    }label:{
                        Image(systemName: "house.circle")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                
                VStack(alignment: .leading){
                    Spacer()
                    
					if let data = manager.selectedItem {
						Text(data.title )
							.font(.largeTitle)
							.bold()
						
						Text(data.subTitle)
					}
                   
                    
                    
                   
                    
                }
                .foregroundColor(.white)
                .frame(minWidth: 200)
                .padding(.vertical)
                .matchedGeometryEffect(id: "\(manager.selectedItem?.id ?? "")-title", in: detailName,properties: [.position,.size,.frame], isSource: manager.selectedItem != nil)
                Spacer()
                
                VStack{
                    Spacer()
                    PickerOfCardView()
						.popoverTip(discountTip)
						
                    
                }
                
                
                
                VStack{
                    Spacer()
					if let data = manager.selectedItem{
						AsyncImageView(imageUrl: data.image)
						
							.scaledToFit()
							.frame(width: 200)
							.padding(.trailing, 100)
							.matchedGeometryEffect(id: "\(data.id)-image", in: detailName,properties: [.position,.size,.frame], isSource: manager.selectedItem != nil)
					}
                }
                
            }
            .opacity( 1 - progress)
            
            VStack{
                Spacer()
                HStack{
                    Button{
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.8)) {
                            manager.selectedItem = nil
                        }
                        
                    }label:{
                        Image(systemName: "chevron.left.2")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                    }
                    
                    
                    Spacer()
					
					if let data = manager.selectedItem {
						AsyncImageView(imageUrl: data.image)
							.scaledToFit()
							.frame(width: 50)
							.padding(.horizontal)
						
						Text(data.title )
							.font(.title3)
							.bold()
							.foregroundColor(.white)
							.lineLimit(1)
						
						
						
						Text(data.subTitle)
							.lineLimit(1)
							.foregroundColor(.white)
					}
                    
                 
                    
                   
                    
                    PickerOfCardView()
						
                    
                    Spacer()
                    
                    
                    
                    
                    
                }
            }
            .opacity(progress)
            .opacity(max(0, min(1, (progress - 0.75) * 4.0)))
            
        }
        
    }
    
    private func  iphoneHeader() -> some View{
        
        ZStack{
            ZStack{
                VStack{
                    Spacer()
                    HStack(alignment: .bottom){
                        Button{
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.8)) {
                                manager.selectedItem = nil
                                
                            }
                            
                        }label:{
                            Image(systemName: "chevron.left.2")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading){
                            
							if let data = manager.selectedItem{
								Text(data.title )
									.font(.title)
									.bold()
									.minimumScaleFactor(0.5)
								
								Text(data.subTitle)
									.minimumScaleFactor(0.5)
							}
                            
                           
                            
                        }
                        .foregroundColor(.white)
						.matchedGeometryEffect(id: "\(manager.selectedItem?.id ?? "")-title", in: detailName,properties: [.position,.size,.frame], isSource: manager.selectedItem != nil)
                        
                        
                        
                        Spacer()
                    }
                }
                
                VStack{
                    HStack{
                        Spacer()
                        PickerOfCardView()
                            .padding(.top, 30)
							.popoverTip(discountTip)
							
                    }
                    Spacer()
                }
                
                
                
                
                HStack{
                    Spacer()
                    VStack{
                        Spacer()
						if let data = manager.selectedItem{
							AsyncImageView(imageUrl: data.image)
							
								.scaledToFit()
								.frame(width: 100)
								.padding(.trailing, 10)
								.matchedGeometryEffect(id: "\(data.id)-image", in: detailName,properties: [.position,.size,.frame], isSource: manager.selectedItem != nil)
						}
                      
                    }
                }
            }
            .padding(10)
            .opacity( 1 - progress)
            
            VStack{
                Spacer()
                HStack{
                    Button{
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.8)) {
                            manager.selectedItem = nil
                        }
                        
                    }label:{
                        Image(systemName: "chevron.left.2")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    
                    
                    VStack(alignment: .leading){
						
						if let data = manager.selectedItem{
							Text(data.title )
								.font(.title3)
								.bold()
								.foregroundColor(.white)
								.lineLimit(1)
								.minimumScaleFactor(0.5)
							
							
							Text(data.subTitle)
								.lineLimit(1)
								.font(.subheadline)
								.foregroundColor(.white)
								.minimumScaleFactor(0.5)
						}
                        
                      
                    }
                    Spacer()
                    
                    PickerOfCardView()
						
                    
                }.padding(.horizontal,10)
            }
            .opacity(progress)
            .opacity(max(0, min(1, (progress - 0.75) * 4.0)))
            
        }
    }
}


struct PickerOfCardView: View {

	@EnvironmentObject var manager:peacock
    @Default(.Cards) var cards
    let nonmember = MemberCardData.nonmember
    var body: some View {
        Picker(selection: Binding(get: {
            manager.selectCard
        }, set: { value in
            manager.selectCard = value
        })) {
            Text("\(nonmember.name)").tag(nonmember)
            
            ForEach(cards, id: \.id){card in
                Text("\(card.title)\(card.name)").tag(card)
                
            }
        } label: {
            Text("选择卡片")
        }.padding()
            .accentColor(.white)
    }
}






#Preview {
    itemsView(detailName: Namespace().wrappedValue)
		.environmentObject(peacock.shared)
}
