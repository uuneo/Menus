//
//  AppSettings.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/8.
//

import SwiftUI
import Defaults

struct AppSettings: View {
    @Default(.homeCardTitle) var homeCardTitle
    @Default(.homeCardSubTitle) var homeCardSubTitle
    @Default(.homeItemsTitle) var homeItemsTitle
    @Default(.homeItemsSubTitle) var homeItemsSubTitle
    @Default(.settingPassword) var settingPassword
    
    var body: some View {
        List {
            Section {
                HStack{
                    Label("会员卡标题", systemImage: "person.text.rectangle")
                        
              
                   TextField("会员卡标题", text: $homeCardTitle)
                        .customField(icon: "pencil")
                    
                    Spacer()
                    Spacer()
                }
                
                HStack{
                    Label("会员卡副标题", systemImage: "person.text.rectangle")
                       
            
                   TextField("会员卡副标题", text: $homeCardSubTitle)
                        .customField(icon: "pencil")
                  
                    Spacer()
                    Spacer()
                }
                
               
            }
            
            Section {
                HStack{
                    Label("项目标题", systemImage: "doc.text")
                        
                   TextField("项目标题", text: $homeItemsTitle)
                        .customField(icon: "pencil")
                    Spacer()
                    Spacer()
                }
                
                HStack{
                    Label("项目副标题", systemImage: "doc.text")
                       

                   TextField("项目副标题", text: $homeItemsSubTitle)
                        .customField(icon: "pencil")
                  
                    Spacer()
                    Spacer()
                }
                
               
            }
            
            Section {
                
                SecureField("输入密码", text: $settingPassword)
                    .customTitleField(icon: "lock", title: "设置密码")
            }
        }
    }
}

#Preview {
    AppSettings()
}
