import Assistant
import Defaults
import SwiftUI

struct BasicSettingsView: View {
    @State private var selectedTab: Int? = 1
    @Binding var columnVisibility: NavigationSplitViewVisibility
    @State private var showAlert: Bool = false
    @State private var showIconPicker: Bool = false

    @Default(.defaultHome) var defaultHome
    @Default(.results) var results
    @Default(.showMenus) var showMenus
    @Default(.remoteUpdateURL) var remoteUpdateURL
    @Default(.settingPassword) var settingPassword
    @Default(.settingLocalPassword) var settingLocalPassword

    let initTip = InitializeDataView()

    var body: some View {
        NavigationStack {
            List(selection: $selectedTab) {
               

                Section {
                    NavigationLink {
                        AppSettings()
                            .navigationTitle("App设置")
                    } label: {
                        Label("App设置", systemImage: "house.circle")
                    }
                    .tag(1)

                    NavigationLink {
                        CalculatorSettings()
                    } label: {
                        Label("计算器设置", systemImage: "house.circle")
                    }.tag(2)

                    NavigationLink {
                        AssistantSettingsView()
                    } label: {
                        Label("智能助手", systemImage: "gear")
                    }.tag(3)

                    if defaultHome == .home && (
                        remoteUpdateURL.isEmpty || settingPassword
                            == settingLocalPassword)
                    {
                        NavigationLink {
                            ExportDataView()
                                .navigationTitle("导出信息")
                        } label: {
                            Label("导出信息", systemImage: "square.and.arrow.up")
                        }.tag(4)

                        NavigationLink {
                            ImportDataView()
                                .navigationTitle("导入信息")
                        } label: {
                            Label("导入信息", systemImage: "square.and.arrow.down")
                        }.tag(5)
                    }

                    Button {
                        self.showIconPicker.toggle()
                    } label: {
                        Label("切换图标", systemImage: "photo.circle")
                    }
                    .tag(6)
                    .sheet(isPresented: $showIconPicker) {
                        NavigationStack {
                            AppIconView()
                        }.presentationDetents([.medium])
                    }

                    if showMenus {
                        NavigationLink {
                            NavigationStack {
                                GiftSettingsView()
                                    .navigationTitle("礼物领取设置")
                            }
                        } label: {
                            Label("礼物领取", systemImage: "app.gift.fill")
                        }.tag(7)
                    }
                } header: {
                    Text(verbatim: "")
                }

            }.navigationTitle("通用设置")
                .onChange(of: selectedTab) { _, _ in
                    self.columnVisibility = .doubleColumn
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("恢复初始化"),
                        message: Text("是否确定恢复初始化"),
                        primaryButton: .destructive(Text("确定"), action: {
                            do {
                                if let realmURL = Realm.Configuration.defaultConfiguration.fileURL {
                                    try FileManager.default.removeItem(at: realmURL)
                                }

                                print("Realm database has been deleted.")
                                exit(0)
                            } catch {
                                print("Failed to delete Realm: \(error)")
                            }
                        }),
                        secondaryButton: .cancel()
                    )
                }
                .scrollDismissesKeyboard(.interactively)
                .toolbar {
                    if defaultHome != .home || settingPassword != settingLocalPassword {
                        ToolbarItem {
                            Button {
                                withAnimation {
                                    peacock.shared.page = defaultHome
                                }
                            } label: {
                                Image(systemName: "xmark")
                            }
                        }
                    }
                }
        }
    }
}

#Preview {
    BasicSettingsView(columnVisibility: .constant(.doubleColumn))
}
