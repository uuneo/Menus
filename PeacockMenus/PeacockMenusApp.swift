import Defaults
import RealmSwift
import SwiftUI
import TipKit

@main
struct PeacockMenusApp: SwiftUI.App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    @Default(.firstStart) var firstStart
    @Default(.defaultHome) var defaultHome
    @Environment(\.scenePhase) var scenePhase
    @State var manager = peacock.shared

    @State private var seconds = 0
    @State private var timer: Timer?

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onChange(of: scenePhase) { _, _ in
                    // 已登录则通过会员服务器认证接口同步价目表
                    if MemberAuth.shared.isLoggedIn {
                        manager.syncMenusFromMemberServer()
                    }
                }
                
                .task {

                    DispatchQueue.main.async {
                        manager.page = defaultHome
                    }

                    try? Tips.configure([
                        .displayFrequency(.immediate),
                        .datastoreLocation(.applicationDefault),
                    ])

                    if firstStart {
                        firstStart = false
                        SettingTipView.startTipHasDisplayed = false
                        createExampleData()
                    }

                    var deletes: [String] = []

                    for (key, value) in Defaults[.giftsNew] {
                        do {
                            let realm = try Realm()
                            try realm.write {
                                let data = realm.objects(VipInfoRealmMode.self)
                                    .where { $0.phone == value.phone }

                                if data.count == 0 {
                                    realm.add(
                                        VipInfoRealmMode
                                            .create(vipinfo: value)
                                    )
                                }
                            }
                            deletes.append(key)
                        } catch {
                            debugPrint(error.localizedDescription)
                        }
                    }

                    for key in deletes {
                        Defaults[.giftsNew].removeValue(forKey: key)
                    }
                }
        }
    }

    func createExampleData() {
        do {
            let realm = try Realm()

            try realm.write {
                if realm.objects(MemberCardRealmData.self).count == 0 {
                    for item in MemberCardDataS {
                        realm.add(item)
                    }
                }

                if realm.objects(CategoryRealmData.self).count == 0 {
                    for item in CategoryDataS {
                        realm.add(item)
                    }
                }

                if realm.objects(SubCategoryRealmData.self).count == 0 {
                    for item in SubCategoryDataS {
                        realm.add(item)
                    }
                }

                if realm.objects(ItemRealmData.self).count == 0 {
                    for item in ItemDataS {
                        realm.add(item)
                    }
                }
            }

        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}
