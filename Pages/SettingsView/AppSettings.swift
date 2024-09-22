//
//  AppSettings.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/8.
//

import SwiftUI
import Defaults
import JDStatusBarNotification

struct AppSettings: View {
    @Default(.homeCardTitle) var homeCardTitle
    @Default(.homeCardSubTitle) var homeCardSubTitle
    @Default(.homeItemsTitle) var homeItemsTitle
    @Default(.homeItemsSubTitle) var homeItemsSubTitle
    @Default(.settingPassword) var settingPassword
    @Default(.autoSetting) var autoSetting
    @StateObject private var manager = peacock.shared
    @State private var uploadProgress:Bool  = false
    var body: some View {
        List {
            
            Section {
                TextField("会员卡标题", text: $homeCardTitle)
                    .customField(icon: "pencil")
            }header: {
                Label("会员卡标题", systemImage: "person.text.rectangle")
            }
            
            Section {
                TextField("会员卡副标题", text: $homeCardSubTitle)
                    .customField(icon: "pencil")
            }header: {
                Label("会员卡副标题", systemImage: "person.text.rectangle")
            }
            
            
            Section {
                TextField("项目标题", text: $homeItemsTitle)
                    .customField(icon: "pencil")
            }header: {
                Label("项目标题", systemImage: "doc.text")
            }
            
            Section {
                TextField("项目副标题", text: $homeItemsSubTitle)
                    .customField(icon: "pencil")
            } header: {
                Label("项目副标题", systemImage: "doc.text")
            }
            
            Section{

                Toggle("自动同步", isOn: $autoSetting.enable)
                    .toggleStyle(SwitchToggleStyle(tint: .accentColor))
            
				TextField("自动同步地址", text: $autoSetting.url)
                    .customField(icon: "link")
                
                
            }header: {
                Label("自动同步地址", systemImage: "link")
			}footer: {
				Text("服务器必须实现GET和POST方法，GET方法返回JSON数据，POST方法接收JSON文件")
			}
			
			
			.onChange(of: autoSetting.enable) { _, newValue in
                if newValue{
					manager.updateItem(url: autoSetting.url)
                }
            }
            
            Section {
                SecureField("输入密码", text: $settingPassword)
                    .customTitleField(icon: "lock")
            }header: {
                Label("设置密码", systemImage: "lock")
            }
        }
        .toolbar {
            ToolbarItem( placement: .topBarLeading){
                Button{
                    uploadProgress = true
                    manager.uploadItem(url: autoSetting.url){success in
                        uploadProgress = false
                        DispatchQueue.main.async{
							
							manager.toast(success ? "项目同步成功" : "项目同步失败", mode: success ? .success : .matrix)
								
                        }
                    }
                }label:{
                    
                    if uploadProgress{
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    }else{
                        Image(systemName: "icloud.and.arrow.up")
                    }
                    
            
                    
                }.disabled(!manager.startsWithHttpOrHttps(autoSetting.url))
            }
           
        }
       
    }
}

#Preview {
    AppSettings()
}
