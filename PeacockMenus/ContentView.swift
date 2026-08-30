import Assistant
import Defaults
import SwiftUI
import UIKit

struct ContentView: View {
    @State private var manager = peacock.shared

    @Default(.firstStart) var firstStart
    @Default(.defaultHome) var defaultHome
    @Default(.showMenus) var showMenus
    @State private var auth = MemberAuth.shared

    var body: some View {
        ZStack(alignment: .top) {
            Group {
                switch manager.page {
                case .home:
                    MenuPriceView()
                case .setting:
                    HomeSettingView()
                        .onDisappear {
                            if MemberAuth.shared.isLoggedIn {
                                manager.syncMenusFromMemberServer()
                            }
                        }
                case .deepseek:
                    AssistantPage()
                case .calculator:
                    NavigationStack {
                        CalculatorView()
                    }
                case .gift:
                    NavigationStack {
                        GiftHomeView()
                    }
                }
            }
            .transition(AnyTransition.opacity.combined(with: .slide))
        }
        .fullScreenCover(isPresented: $manager.fullPage) {
            ScanView { code in
                if let url = URL(string: code),
                   url.scheme == "http" || url.scheme == "https"
                {
                    let scanned = code
                    Task {
                        let ok = await MemberAuth.shared.checkServer(scanned)
                        if !ok {
                            await MainActor.run {
                                manager.toast("不是有效的接口地址", mode: .error)
                            }
                            return
                        }
                        await MainActor.run {
                            Defaults[.memberServerURL] = scanned
                            // 更新到会员服务器地址, 后续登录/同步都用它
                            MemberAuth.shared.serverURL = scanned
                            Defaults[.defaultHome] = .home
                            Defaults[.showMenus] = true
                            manager.page = .home
                            manager.toast("接口连接成功", mode: .success)
                        }
                    }
                }
                return true
            }
        }
        .fullScreenCover(isPresented: $manager.showVipHairCourse) {
            NavigationStack {
                if auth.isLoggedIn {
                    MemberSearchView()
                } else {
                    MemberLoginView()
                }
            }
        }
    }

    @ViewBuilder
    func AssistantPage() -> some View {
        NavigationStack {
            AssistantView {
                Section {
                    ForEach(Page.arr, id: \.self) { item in
                        if item != .deepseek {
                            if item != .home {
                                Button {
                                    withAnimation {
                                        manager.page = item
                                    }
                                } label: {
                                    Label(item.name, systemImage: item.rawValue)
                                }
                            } else {
                                if showMenus {
                                    Button {
                                        withAnimation {
                                            manager.page = item
                                        }
                                    } label: {
                                        Label(
                                            item.name,
                                            systemImage: item.rawValue
                                        )
                                    }
                                }
                            }
                        }
                    }
                }
            } toast: { mode, msg in
                DispatchQueue.main.async {
                    switch mode {
                    case .error:
                        manager.toast(msg, mode: .error)
                    case .success:
                        manager.toast(msg, mode: .success)
                    }
                }

            } logoBtn: {
                self.showMenus.toggle()
                if showMenus {
                    manager.toast("Unlock A Surprise!")
                } else {
                    manager.toast("Close")
                }

            } close: {
                manager.page = defaultHome
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        manager.fullPage = true
                    } label: {
                        Image(systemName: "qrcode.viewfinder")
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
        
}
