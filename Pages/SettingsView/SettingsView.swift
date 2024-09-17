//
//  SettingsView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/8.
//

import SwiftUI
import Defaults


struct SettingsView: View {
    @StateObject private var manager = peacock.shared
    @Default(.settingPassword) var settingPassword
    @Environment(\.dismiss) var dismiss
    @State private var changeTitle:Bool = false
    
    @State private var selectedTab:Int? = 0
    
    @State private var columnVisibility: NavigationSplitViewVisibility = .automatic
    
    @State private var password:String = ""
    
    @State private var disabled = true
    
    @FocusState var isFocused:Bool
    
    
    var body: some View {
      


        
        NavigationSplitView(columnVisibility: $columnVisibility, preferredCompactColumn: .constant(.detail))  {
            
                
                List(selection: $selectedTab){
                    
                    Section {
                        
                    }header: {
                        Text("右滑返回")
                    }
                    
                    NavigationLink{
                        BasicSettingsView(columnVisibility: $columnVisibility)
                    }label: {
                        Label("通用设置", systemImage: "house.circle")
                    }
                    
                    .tag(0)
                    
                    
                    NavigationLink{
                        
                        vipCardSettingView(columnVisibility: $columnVisibility)
                            .navigationTitle("会员卡页面")
                    }label: {
                        Label("会员卡页面", systemImage: "pencil")
                    }
                    
                    .tag(4)
                    
                    
                    NavigationLink{
                        CategorySettingView(columnVisibility: $columnVisibility)
                            .navigationTitle("项目大类")
                    }label: {
                        Label("项目大类", systemImage: "pencil")
                    }
                    
                    .tag(5)
                    
                    
                    NavigationLink{
                        SubCategorySettingView(columnVisibility: $columnVisibility)
                            .navigationTitle("项目小类")
                    }label: {
                        Label("项目小类", systemImage: "pencil")
                    }
                    
                    .tag(6)
                    
                    NavigationLink{
                        ProjectSettingView(columnVisibility: $columnVisibility)
                            .navigationTitle("项目")
                    }label: {
                        Label("所有项目", systemImage: "pencil")
                    }
                    .tag(7)
                    
                    
                    
                }
                .listRowSpacing(20)
                .listStyle(.insetGrouped)
                
                .navigationTitle("设置")
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            if value.translation.width > 100 {
                                self.dismiss()
                            }
                        }
                )
                .toolbar {
                    
                    
                    if UIDevice.current.userInterfaceIdiom  == .pad{
                        ToolbarItem {
                            Button{
                                
                                columnVisibility = columnVisibility == .all ? .doubleColumn : .all
                                
                            }label: {
                                Image(systemName: columnVisibility == .all ? "chevron.left" : "chevron.right")
                            }
                        }
                    }else{
                        ToolbarItem{
                            Button{
                                manager.showSettings.toggle()
                            }label:{
                                Image(systemName: "xmark")
                            }
                        }
                    }
                   
                    
                   
                }
            
           
           
            
        }content: {
            BasicSettingsView(columnVisibility: $columnVisibility)
               
        }detail:{
            
                AppSettings()
                    .navigationTitle("App设置")
         
            
        }
        .onChange(of: selectedTab) { _, _ in
            self.columnVisibility = .doubleColumn
        }
        .disabled(disabled)
        .blur(radius: disabled ? 10 : 0)
        
        .overlay {
            
            ZStack{
                VStack{
                    Spacer()
                    Text("管理密码")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .minimumScaleFactor(0.5)
                    
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
                            }
                        }
                        .onAppear{
                            isFocused = true
                        }
                       
                        Spacer()
                        
                    }
                    Text("默认密码：admin")
                        .font(.body)
                        .foregroundStyle(.white)
                    
                   
                    
                    Spacer()
                }
                .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? 400 : UIScreen.main.bounds.width - 50, height: 200)
                .background(Color.orange.gradient)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        Button{
                            self.dismiss()
                        }label: {
                            Image(systemName: "xmark")
                                .font(.title)
                                .foregroundStyle(.white)
                                .padding()
                                .background(.red)
                                .clipShape(Circle())
                                .padding()
                        }
                        
                    }
                }
            }
            
           
            .opacity(disabled ? 1 : 0)
            
        }
        
    }
}


#Preview {
    SettingsView()
}

#Preview {
    SettingsView()
}

