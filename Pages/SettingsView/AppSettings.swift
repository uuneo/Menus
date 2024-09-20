//
//  AppSettings.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/8.
//

import SwiftUI
import Defaults
import SwiftMessages

struct AppSettings: View {
    @Default(.homeCardTitle) var homeCardTitle
    @Default(.homeCardSubTitle) var homeCardSubTitle
    @Default(.homeItemsTitle) var homeItemsTitle
    @Default(.homeItemsSubTitle) var homeItemsSubTitle
    @Default(.settingPassword) var settingPassword
    @Default(.autoSetting) var autoSetting
    @StateObject private var manager = peacock.shared
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
            }.onChange(of: autoSetting.enable) { _, newValue in
                if newValue{
                    Task{
                        if let success  =  try? await manager.updateItem(url: autoSetting.url){
                            
                            DispatchQueue.main.async {
                                manager.message = DemoMessage(title: "提示", body: success ? "更新成功"  : "更新失败")
                            }
                        }else{
                            DispatchQueue.main.async {
                                manager.message = DemoMessage(title: "提示", body: "地址/网络/格式错误")
                                self.autoSetting.enable = false
                            }
                        }
                    }
                }
            }
            
            Section {
                SecureField("输入密码", text: $settingPassword)
                    .customTitleField(icon: "lock")
            }header: {
                Label("设置密码", systemImage: "lock")
            }
        }
       
    }
}

#Preview {
    AppSettings()
}
