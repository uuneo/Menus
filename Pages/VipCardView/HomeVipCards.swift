//
//  HomeVipCards.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/13.
//

import SwiftUI
import Defaults


struct HomeVipCards: View {
    var Namespace:Namespace.ID
    @Default(.Cards) var cards
    @Default(.homeCardTitle) var title
    @Default(.homeCardSubTitle) var subTitle
    
    @State private var showDetail:Bool = false
    var body: some View {
        ZStack{
            VStack(alignment: .leading) {
                
                
                VStack(alignment: .leading){
                   
                        
                    Text(title)
                        .font(.title)
                       .fontWeight(.heavy)
              
                       
                     Text(subTitle)
                        .foregroundColor(.gray)
                }.padding(.leading, 60)
                
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
                    VipCardView(item: item, size: CGSize(width: 355, height: 230), show: $showDetail)
                        .rotation3DEffect(
                            .degrees(proxy.frame(in: .global).minX / -10),
                            axis: (x: 0, y: 1, z: 0), perspective: 1
                        )
                        .shadow(color: Color("Shadow").opacity(0.3),
                                radius: 30, x: 0, y: 30)
                        .blur(radius: abs(proxy.frame(in: .global).minX) / 40)
                        .padding(20)
                    
                }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: 300)
    }
    
    
    
    
    private var ipadViews: some View{
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center, spacing: 30) {
              ForEach($cards) { item in
                  VipCardView(item: item,size: CGSize(width: 355, height: 230), show: $showDetail)
                      .padding()
              }
               
           }
           .padding()
           .padding(.leading, 10)
        }
         
    }
    
    
    
}

#Preview {
    HomeVipCards(Namespace: Namespace().wrappedValue)
}
