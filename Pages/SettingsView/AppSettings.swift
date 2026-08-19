import Defaults
import RealmSwift
import SwiftUI
import TipKit

struct AppSettings: View {

    @Default(.settingPassword) var settingPassword
    @Default(.settingLocalPassword) var settingLocalPassword
    @Default(.remoteUpdateURL) var remoteUpdateURL

    @Default(.defaultHome) var defaultHome

    @ObservedResults(MenusHomeInfo.self) var homeInfos
    @Default(.showMenus) var showMenus
    
    @EnvironmentObject var manager: peacock

    @State private var passwd: String = ""
    let editTip = EditChangeTipView()

    var body: some View {
        List {
            TipView(editTip)
            
            Section {
                Picker(selection: $defaultHome, label: Text("默认首页")) {
                    ForEach(Page.arr, id: \.self) { icon in
                        if icon == .home {
                            if showMenus {
                                Label(icon.name, systemImage: icon.rawValue)
                            }
                        } else {
                            Label(icon.name, systemImage: icon.rawValue)
                        }
                    }
                }

            } header: {
                Label("切换默认首页", systemImage: "house.circle")
            }

            Section {
                TextField("自动同步地址", text: $remoteUpdateURL)
                    .customField(icon: "link", data: $remoteUpdateURL)
                    .disabled(settingPassword != settingLocalPassword)
                    .onChange(of: remoteUpdateURL) { _, newValue in
                        if let url = URL(string: newValue) {
                            manager
                                .updateItem(url: url.absoluteString, toast: true) { success in
                                    if success {
                                        Defaults[.defaultHome] = .home
                                        Defaults[.showMenus] = true
                                        Task{@MainActor in
                                            manager.page = .home
                                        }
                                    }
                                }
                        }
                    }


            } header: {
                Label("自动同步地址", systemImage: "link")
            } footer: {
                Text("服务器必须实现GET和POST方法，GET方法返回JSON数据，POST方法接收JSON文件")
            }
            
            Section {
                SecureField("输入密码", text: $settingPassword)
                    .disabled(settingPassword != settingLocalPassword)
                    .customField(icon: "lock",data: $settingPassword)
                    

            } header: {
                Label("校验密码", systemImage: "lock")
            }

            if defaultHome == .home, let homeInfo = homeInfos.first {
                MenuHomeItemsSettingsView(homeInfo: homeInfo)
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .toolbar {
            ToolbarItem {
                Button {
                    manager.fullPage = true
                } label: {
                    Image(systemName: "qrcode.viewfinder")
                }
            }
            if !settingPassword.isEmpty{
                ToolbarItem(placement: .topBarTrailing) { 
                    if settingPassword == settingLocalPassword{
                        Image(systemName: "lock.open.display")
                    }else{
                        Button { 
                            manager.showPassView = true
                        } label: { 
                            Label { 
                                Text("校验密码")
                            } icon: { 
                                Image(systemName: "person.badge.key")
                            }

                        }
                    }
                }
            }
            
        }
    }
}

struct MenuHomeItemsSettingsView: View {
    @ObservedRealmObject var homeInfo: MenusHomeInfo
    var body: some View {
        Section {
            TextField("菜单标题", text: $homeInfo.menusName)
                .customField(icon: "pencil", data: $homeInfo.menusName)
        } header: {
            Label("菜单标题", systemImage: "doc.text")
        }

        Section {
            TextField("子菜单标题", text: $homeInfo.menusSubName)
                .customField(icon: "pencil", data: $homeInfo.menusSubName)
        } header: {
            Label("子菜单标题", systemImage: "doc.text")
        }

        Section {
            TextField("菜单底部", text: $homeInfo.menusFooter)
                .customField(icon: "pencil", data: $homeInfo.menusFooter)
        } header: {
            Label("菜单底部", systemImage: "doc.text")
        }

        Section {
            TextField("菜单图标", text: $homeInfo.menusImage)
                .customField(icon: "photo", data: $homeInfo.menusImage)

        } header: {
            Label("菜单图标", systemImage: "photo")
        }

        Section {
            TextField("会员卡标题", text: $homeInfo.homeCardTitle)
                .customField(icon: "pencil", data: $homeInfo.homeCardTitle)
        } header: {
            Label("会员卡标题", systemImage: "person.text.rectangle")
        }

        Section {
            TextField("会员卡副标题", text: $homeInfo.homeCardSubTitle)
                .customField(icon: "pencil", data: $homeInfo.homeCardSubTitle)
        } header: {
            Label("会员卡副标题", systemImage: "person.text.rectangle")
        }

        Section {
            TextField("项目标题", text: $homeInfo.homeItemsTitle)
                .customField(icon: "pencil", data: $homeInfo.homeItemsTitle)
        } header: {
            Label("项目标题", systemImage: "doc.text")
        }

        Section {
            TextField("项目副标题", text: $homeInfo.homeItemsSubTitle)
                .customField(icon: "pencil", data: $homeInfo.homeItemsSubTitle)
        } header: {
            Label("项目副标题", systemImage: "doc.text")
        }
    }
}

#Preview {
    AppSettings()
        .environmentObject(peacock.shared)
}
