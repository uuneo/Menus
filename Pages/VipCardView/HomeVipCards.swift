//
//  HomeVipCards.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/13.
//

import SwiftUI
import Defaults
import TipKit


struct HomeVipCards: View {
    var Namespace:Namespace.ID
    @Default(.Cards) var cards
    @Default(.homeCardTitle) var title
    @Default(.homeCardSubTitle) var subTitle
	@EnvironmentObject var manager:peacock
	
    var body: some View {
        ZStack{
            VStack(alignment: .leading) {
                
                
                VStack(alignment: .leading){
                   
                        
                    Text(title)
                        .font(.title)
                       .fontWeight(.heavy)
              
                       
                     Text(subTitle)
                        .foregroundColor(.gray)
                }.padding(.leading, 30)
                
                if ISPAD{
                    ipadViews
                }else{
                    iphoneViews
                }

              
            }
            
            
        }
    }
    
    private var iphoneViews: some View{
        TabView{
            ForEach($cards) { item in
                GeometryReader { proxy in
					VipCardView(item: item, size: CGSize(width: 355, height: 230), show: $manager.showCardDetail)
						.rotation3DEffect(
							.degrees(proxy.frame(in: .global).minX / -10),
							axis: (x: 0, y: 1, z: 0), perspective: 1
						)
						.blur(radius: abs(proxy.frame(in: .global).minX) / 40)
						.padding(20)
                }
			}
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: 300)
    }
    
    
    
    
	private var ipadViews: some View{
		ScrollViewReader { proxy in
			ScrollView(.horizontal, showsIndicators: false) {
				HStack(alignment: .center, spacing: 0) {
					
					scallBtn( proxy: proxy, isHead: true)
					
					
					ForEach($cards) { item in
						VipCardView(item: item,size: CGSize(width: 355, height: 230), show: $manager.showCardDetail)
							.scaleEffect(0.95)
							.padding(.horizontal, 20)
							.id(item.id)
						
					}
					scallBtn( proxy: proxy, isHead: false)
					
				}
				.padding(.leading, 10)
				.padding(.vertical)
			}
		}
		
		
	}
	
    
    
}

#Preview {
    HomeVipCards(Namespace: Namespace().wrappedValue)
		.environmentObject(peacock.shared)
}



