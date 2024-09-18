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
