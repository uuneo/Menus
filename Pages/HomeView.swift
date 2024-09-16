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


let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
let statusBarHeight = windowScene?.statusBarManager?.statusBarFrame.height ?? 0



struct HomeView: View {
    @Namespace var NewHomeName
    @State var showDetail:Bool = false
    @StateObject var manager = peacock.shared
    var body: some View {
        ZStack(alignment: .top){
            
            
            ScrollView(.vertical, showsIndicators: false) {
       
                HomeVipCards(Namespace: NewHomeName)
                    .padding(.top, 50)
                    
                HomeItemsView(NewHomeName: NewHomeName, showDetail: $showDetail)
                    
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
            
           
            
            VStack{
                itemsView(show: $showDetail,detailName: NewHomeName)
                    .background(.ultraThinMaterial)
                    .opacity(showDetail ? 1 : 0)
                    
            }
            

            
        }.navigationDestination(isPresented: $manager.showSettings) {
            ZStack(alignment: .topTrailing){
                SettingsView()
                    .navigationBarBackButtonHidden()
                   
                Button{
                    withAnimation(.spring()){
                        manager.showSettings.toggle()
                    }
                   
                }label: {
                   Image(systemName: "xmark")
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                        .padding()
                }
               
            }
           
           
        }
        
        
        
        
    }
    
    
}


#Preview {
    
    NavigationStack{
        HomeView()
    }
    
}
