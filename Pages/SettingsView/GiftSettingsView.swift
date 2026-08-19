import Defaults
import RealmSwift
import SwiftUI

struct GiftSettingsView: View {
    
    @ObservedResults(VipInfoRealmMode.self, sortDescriptor: SortDescriptor(
        keyPath: \VipInfoRealmMode.createDate, ascending: false
    )) var vipGiftlist
    @Default(.searchApi) var searchApi
    @Default(.searchAuth) var searchAuth
    @Default(.giftShow) var giftShow
    @Default(.settingPassword) var settingPassword
    @Default(.settingLocalPassword) var settingLocalPassword
    @Default(.remoteUpdateURL) var remoteUpdateURL
    @State private var showDelete = false

    @FocusState private var searchFocus
    @FocusState private var searchPassword
    var body: some View {
        List {
            Section {
                Defaults.Toggle("礼物领取开关", systemImage: "app.gift.fill", key: .giftShow)
                    .onChange(of: giftShow) { _, newValue in
                        if newValue && !searchApi.hasPrefix("http") {
                            self.giftShow = false
                        }
                    }

                if !giftShow {
                    TextField("API", text: $searchApi)
                        .focused($searchFocus)
                        .customField(focus: searchFocus, icon: "link", data: $searchApi)

                    SecureField("key", text: $searchAuth)
                        .focused($searchPassword)
                        .customField(focus: searchPassword, icon: "key", data: $searchAuth)
                }

            }.disabled(
                !remoteUpdateURL.isEmpty && settingPassword != settingLocalPassword
            )

            ForEach(vipGiftlist, id: \.id) { value in
                HStack {
                    Text(value.phone)
                    Spacer()
                    Text(value.name)

                    Text(verbatim: "-")

                    Text(value.cardLevel)
                    Spacer()
                    Text(value.createDate.yymm)
                    
                }
                .minimumScaleFactor(0.5)
                .padding()
                .font(.title2)
            }
            .onDelete(perform: $vipGiftlist.remove)
        }
        .scrollDismissesKeyboard(.interactively)
        .toolbar {
            if vipGiftlist.count > 0 {
                ToolbarItem {
                    Text("\(vipGiftlist.count)")
                        .padding(.horizontal)
                        .contentShape(Rectangle())
                        .onTapGesture(count: showDelete ? 1 : 5) {
                            self.showDelete.toggle()
                        }
                }
            }

            if !vipGiftlist.isEmpty {
                ToolbarItem(placement: .topBarLeading) {
                    ShareLink(item: exportData())
                }
            }

            if showDelete && !vipGiftlist.isEmpty {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        // TODO: 删除所有数据
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
        }
    }

    func exportData() -> String {
        var results = ""
        var index = 0

        for item in vipGiftlist {
            index += 1
            let line = "\(index),\(item.phone),\(item.name),\(item.cardLevel),\(item.createDate.yymm)\n"
            results.append(line)
        }
        return results
    }
}

extension Date {
    var yymm: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: self)
    }

    var yyyy: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: self)
    }
}
