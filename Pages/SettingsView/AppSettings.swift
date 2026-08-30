import Defaults
import RealmSwift
import SwiftUI
import TipKit

struct AppSettings: View {

    @Default(.defaultHome) var defaultHome

    @ObservedResults(MenusHomeInfo.self) var homeInfos
    @Default(.showMenus) var showMenus

   @State private var manager = peacock.shared

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
        
}
