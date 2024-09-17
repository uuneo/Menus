//
//  HomeIphoneView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/17.
//

import SwiftUI
import Defaults


struct HomeIphoneView:View {
    @StateObject var manager = peacock.shared

    
    
    
    @Default(.categoryItems) var items
    @Default(.homeItemsTitle) var title
    @Default(.homeItemsSubTitle) var subTitle
    @Default(.cards) var cards
    @Default(.homeCardTitle) var title2
    @Default(.homeCardSubTitle) var subTitle2
    
    @Namespace var  NewHomeName
    
    @State var showModel = false
    @State var showDetail = false
    var body: some View {
        ZStack(alignment: .top){
            ScrollView {
                VStack(alignment: .leading){
                    VStack(alignment: .leading){
                       
                            
                        Text(title2)
                            .font(.title)
                           .fontWeight(.heavy)
                  
                           
                         Text(subTitle2)
                            .foregroundColor(.gray)
                    }.padding(.leading)
                    
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
                .padding(.top , 78)
                VStack {
                    HStack {
                        VStack {
                            Text(title)
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                            Text(subTitle)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    .padding(.leading)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 30) {
                            ForEach($items, id: \.id) { item in
                                Button(action: {
                                    withAnimation {
                                        self.showModel = true
                                        manager.selectedItem = item.wrappedValue
                                    }
                                }) {
                                    GeometryReader { geometry in
                                        HStack{
                                            categoryCardView(item: item, NewHomeName: NewHomeName, show: showModel)
                                        }
                                            .rotation3DEffect(Angle(degrees: Double(geometry.frame(in: .global).minX - 40) / -40), axis: (x: 0, y: 10, z: 0))
                                    }
                                    .frame(width: 246, height: 360)
                                }
                                
                            }
                        }
                        .padding(.leading, 30)
                        Spacer()
                    }
                    
                }
               
               
            }
            .blur(radius: manager.showSettings ? 20 : 0)
            .disabled(manager.showSettings)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            
            HStack{
                Spacer()
                Spacer()
                MenuButton(show: $manager.showSettings)
                    .offset(x: 40)
               
            }
            .offset(y: manager.showSettings ? -100 : 60)
            .animation(.bouncy(duration: 0.5, extraBounce: 0.2), value: manager.showSettings)
            
            ItemsIphoneView(show: $showModel,detailName: NewHomeName)
                .background(.ultraThinMaterial)
                .opacity(showModel ? 1 : 0)
                .offset(y:showModel ? 0 : 500)
                
                      
        }
        .fullScreenCover(isPresented: $manager.showSettings){
            ZStack{
                
                SettingsView()
                    .navigationBarBackButtonHidden()
                if UIDevice.current.userInterfaceIdiom  == .pad{
                
                }
            }
           
        }
      
    }
}



#Preview {
    HomeIphoneView()
}


