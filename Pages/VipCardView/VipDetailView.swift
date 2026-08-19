//
//  VipDetailView.swift
//  PeacockMenus
//
//  Created by lynn on 2025/6/28.
//

import Defaults
import RealmSwift
import SwiftUI

struct VipDetailView: View {
    @ObservedRealmObject var item: MemberCardRealmData
    @State private var select: MemberCardRealmData
   @State private var manager = peacock.shared

    @ObservedResults(MemberCardRealmData.self, sortDescriptor: SortDescriptor(
        keyPath: \MemberCardRealmData.sort, ascending: true
    )) var cards

    init(item: MemberCardRealmData, dismiss: @escaping () -> Void) {
        self.item = item
        _select = State(wrappedValue: item)
        self.dismiss = dismiss
    }

    var dismiss: () -> Void
    var body: some View {
        NavigationStack {
            VStack {
                CardsView()
                ScrollView(.vertical) {
                    VStack {
                        HStack {
                            Text(select.footer)
                                .font(.headline)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        .padding(20)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.top)
                        .padding(.horizontal, 30)
                    }
                }
            }
            .navigationTitle(select.subTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .padding()
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                }
            }
        }
    }

    @ViewBuilder
    func CardsView() -> some View {
        TabView(selection: $select) {
            ForEach(cards) { item in
                GeometryReader { proxy in
                    HStack {
                        Spacer()
                        VipCardView(
                            item: item,
                            size: CGSize(
                                width: min(proxy.size.width - (ISPAD ? 100 : 20), 500),
                                height: proxy.size.height - (ISPAD ? 10 : 30)
                            ),
                            big: true
                        )

                        Spacer()
                    }

                }.tag(item)
            }
        }
        .tabViewStyle(.page)
        .frame(height: 300)
    }
}
