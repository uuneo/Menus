//
//  HomeVipCards.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/13.
//

import SwiftUI
import Defaults


struct HomeVipCards: View {
    var items = VipCardData.datas
    var Namespace:Namespace.ID
    @Default(.cards) var cards
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

               ScrollView(.horizontal, showsIndicators: false) {
                   HStack(alignment: .center, spacing: 30) {
                     ForEach($cards) { item in
                         VipCardView(item: item,size: CGSize(width: 300, height: 200), show: $showDetail)
                     }
                      
                  }
                   
                  .padding(20)
                  .padding(.leading, 10)
               }
            }
            
            
        }
    }
}

#Preview {
    HomeVipCards( Namespace: Namespace().wrappedValue)
}
