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
	@Default(.menusName) var menusName
	@Default(.menusSubName) var subName
	@Default(.menusFooter) var menusFooter
	@Default(.menusImage) var menusImage
 
	@EnvironmentObject var manager:peacock
    
    var body: some View {
        List {
			
			Section {
				TextField("菜单标题", text: $menusName)
					.customField(icon: "pencil",data: $menusName)
			}header: {
				Label("菜单标题", systemImage: "doc.text")
			}
			
			Section {
				TextField("子菜单标题", text: $subName)
					.customField(icon: "pencil",data: $subName)
			}header: {
				Label("子菜单标题", systemImage: "doc.text")
			}
			
			
			Section {
				TextField("菜单底部", text: $menusFooter)
					.customField(icon: "pencil",data: $menusFooter)
			}header: {
				Label("菜单底部", systemImage: "doc.text")
			}
			
			Section{
				TextField("菜单图标", text: $menusImage)
					.customField(icon: "photo",data: $menusImage)
				
			}header: {
				Label("菜单图标", systemImage: "photo")
			}
            
            Section {
                TextField("会员卡标题", text: $homeCardTitle)
					.customField(icon: "pencil",data: $homeCardTitle)
            }header: {
                Label("会员卡标题", systemImage: "person.text.rectangle")
            }
            
            Section {
                TextField("会员卡副标题", text: $homeCardSubTitle)
					.customField(icon: "pencil",data: $homeCardSubTitle)
            }header: {
                Label("会员卡副标题", systemImage: "person.text.rectangle")
            }
            
            
            Section {
                TextField("项目标题", text: $homeItemsTitle)
					.customField(icon: "pencil",data: $homeItemsTitle)
            }header: {
                Label("项目标题", systemImage: "doc.text")
            }
            
            Section {
                TextField("项目副标题", text: $homeItemsSubTitle)
					.customField(icon: "pencil",data: $homeItemsSubTitle)
            } header: {
                Label("项目副标题", systemImage: "doc.text")
            }
            
            Section{

                Toggle("自动同步", isOn: $autoSetting.enable)
                    .toggleStyle(SwitchToggleStyle(tint: .accentColor))
            
				TextField("自动同步地址", text: $autoSetting.url)
					.customField(icon: "link",data: $autoSetting.url)
                
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
					.customField(icon: "lock",data: $settingPassword)
            }header: {
                Label("设置密码", systemImage: "lock")
            }
        }
       
       
    }
}

#Preview {
    AppSettings()
		.environmentObject(peacock.shared)
}

