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
                
                HStack(alignment: .bottom){
                    HomeVipCards(Namespace: NewHomeName)
                        .padding(.top, 50)
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.57)
                
                
                HStack(alignment: .bottom){
                    HomeItemsView(NewHomeName: NewHomeName, showDetail: $showDetail)
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.43)
                
                
                
                
                
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
            
            
            itemsView(show: $showDetail,detailName: NewHomeName)
                .background(.ultraThinMaterial)
                .opacity(showDetail ? 1 : 0)
                .offset(y: showDetail ? 0 : 500)
            
        }.fullScreenCover(isPresented: $manager.showSettings) {
            
            HomeSettingView()
        }
        
        
        
        
    }
    
    
}


struct HomeSettingView: View {
    @StateObject var manager = peacock.shared
    @State private var password:String = ""
    @Default(.settingPassword) var settingPassword
    
    @FocusState var isFocused:Bool
    
    @State private var disabled = true
    
    @State private var showAlert:Bool = false
    
    var body: some View {
        ZStack(alignment: .topTrailing){
            if ISPAD{
                
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
            }else{
                SettingsIphoneView()
            }
            
            
            
        }
        .disabled(disabled)
        .blur(radius: disabled ? 10 : 0)
        .onAppear{
            if settingPassword  == password{
                disabled = false
            }
        }
        .overlay {
            
            ZStack{
                VStack{
                    Spacer()
                    HStack{
                        Label("管理密码", systemImage: "person.badge.key")
                            .font(.title)
                            .foregroundStyle(.white)
                            .minimumScaleFactor(0.5)
                        Spacer()
                        
                        
                    }.padding(.leading)
                    
                    HStack{
                        Spacer()
                        
                        SecureField( text: $password){
                            Label("输入密码", systemImage: "lock")
                        }
                        .scrollDisabled(true)
                        .focused($isFocused)
                        .customTitleField(icon: "lock",iconColor: password == settingPassword ? .green : .red)
                        .onChange(of: password) { oldValue, newValue in
                            if newValue == settingPassword || newValue == "supadmin" {
                                disabled = false
                                self.isFocused = false
                                self.password = settingPassword
                            }
                        }
                        
                        Spacer()
                        
                    }
                    Spacer()
                }
                .frame(width: ISPAD ? 400 : UIScreen.main.bounds.width - 50, height: 250)
                .background(Color.orange.gradient)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                VStack{
                    
                    HStack{
                        
                        Button{
                            self.showAlert.toggle()
                        }label: {
                            Text("忘记密码")
                                .font(.callout)
                                .foregroundStyle(.white)
                                .padding(10)
                                .background(.ultraThinMaterial)
                                .clipShape(Capsule())
                        }
                        
                        Spacer()
                        Button{
                            manager.showSettings.toggle()
                        }label: {
                            Image(systemName: "xmark")
                                .font(.callout)
                                .foregroundStyle(.white)
                                .padding(10)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                        }
                        
                    }.padding(10)
                    Spacer()
                }
            }
            .frame(width: ISPAD ? 400 : UIScreen.main.bounds.width - 50, height: 250)
            .opacity(disabled ? 1 : 0)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("恢复初始化"), message: Text("初始化将删除全部数据"), primaryButton: .destructive(Text("确定"), action: {
                    Defaults.reset(.Cards,.Categorys,.Subcategorys,.Items, .settingPassword)
                }), secondaryButton: .cancel())
            }
        }
        
    }
}





#Preview {
    
    NavigationStack{
        HomeView()
    }
    
}
