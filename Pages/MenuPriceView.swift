import Defaults
import SwiftUI

struct MenuPriceView: View {
    @State private var manager = peacock.shared
    @Default(.giftShow) var showGift
    @Default(.remoteUpdateURL) var remoteUpdateURL
    var body: some View {
        NavigationStack {
            VStack {
                HomeVipCards()
                    .padding(.top, ISPAD ? 50 : 80)
                HomeCategoryPage()
                    .padding(.bottom, 30)
            }
            .ignoresSafeArea()
            .frame(width: windowWidth, height: windowHeight)
            .background(Color.background)
            .toolbar {
                if showGift {
                    ToolbarItem {
                        Button {
                            withAnimation(.bouncy(duration: 0.3, extraBounce: 0.2)) {
                                manager.page = .gift
                            }

                        } label: {
                            Label("礼品领取", systemImage: "gift.fill")
                                .foregroundStyle(.pink)
                        }
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Section {
                            Button {
                                withAnimation {
                                    manager.page = .setting
                                }

                            } label: {
                                Label("设置", systemImage: "gear")
                            }
                        }

                        Section {
                            Button {
                                manager.fullPage = true
                            } label: {
                                Label("扫一扫", systemImage: "qrcode.viewfinder")
                            }
                        }

                        if let url = URL(string: remoteUpdateURL) {
                            Section {
                                Button {
                                    manager.updateItem(url: url.absoluteString, toast: true)
                                } label: {
                                    Label(
                                        "更新价目表",
                                        systemImage: "arrow.trianglehead.2.clockwise.rotate.90.circle"
                                    )
                                }
                            }
                        }

                        Section {
                            Button {
                                withAnimation {
                                    manager.page = .deepseek
                                }
                            } label: {
                                Label("智能助手", systemImage: Page.deepseek.rawValue)
                            }
                        }

                        Button {
                            withAnimation {
                                manager.page = .calculator
                            }
                        } label: {
                            Label("计算器", systemImage: "123.rectangle")
                        }

                    } label: {
                        Image(systemName: "filemenu.and.selection")
                    }
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    ContentView()
}

extension View {
    var windowWidth: CGFloat {
        UIScreen.main.bounds.width
    }

    var windowHeight: CGFloat {
        UIScreen.main.bounds.height
    }
}
