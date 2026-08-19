//
//  HomeVipCards.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/13.
//

import Defaults
import RealmSwift
import SwiftUI
import TipKit

struct HomeVipCards: View {
    @ObservedResults(MemberCardRealmData.self, sortDescriptor: SortDescriptor(
        keyPath: \MemberCardRealmData.sort, ascending: true
    )) var cards
    @ObservedResults(MenusHomeInfo.self) var homeInfos

   @State private var manager = peacock.shared

    @Namespace private var homeSpace
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let homeInfo = homeInfos.first{
                    VStack(alignment: .leading) {
                        Text(homeInfo.homeCardTitle)
                            .font(.title)
                            .fontWeight(.heavy)

                        Text(homeInfo.homeCardSubTitle)
                            .foregroundColor(.gray)
                    }.padding(.leading, 30)
                }
                
                Spacer()
            }

            iphoneViews
                .if(ISPAD) { _ in
                    ipadViews
                }
        }
        .sheet(item: $manager.selectVip) { item in
            VipDetailView(item: item) {
                manager.selectVip = nil
            }
            .navigationTransition(
                .zoom(sourceID: item.id, in: homeSpace)
            )
        }
    }

    private var iphoneViews: some View {
        TabView {
            ForEach(cards) { item in
                GeometryReader { proxy in
                    HStack {
                        Spacer()
                        VipCardView(item: item, size: CGSize(width: 355, height: 230))
                            .rotation3DEffect(
                                .degrees(proxy.frame(in: .global).minX / -10),
                                axis: (x: 0, y: 1, z: 0), perspective: 1
                            )
                            .blur(radius: abs(proxy.frame(in: .global).minX) / 40)
                            .padding(10)
                            .onTapGesture {
                                manager.selectVip = item
                            }
                            .matchedTransitionSource(
                                id: item.id,
                                in: homeSpace
                            )
                        Spacer()
                    }
                }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: 250)
    }

    private var ipadViews: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 0) {
                    scallBtn(proxy: proxy, isHead: true)

                    ForEach(cards) { item in
                        VipCardView(item: item, size: CGSize(width: 355, height: 230))
                            .scaleEffect(0.95)
                            .padding(.horizontal, 20)
                            .id(item.id)
                            .onTapGesture {
                                manager.selectVip = item
                            }
                            .matchedTransitionSource(id: item.id, in: homeSpace)
                    }
                    scallBtn(proxy: proxy, isHead: false)
                }
                .padding(.leading, 10)
                .padding(.vertical)
            }
        }
    }
}

extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    /// https://www.avanderlee.com/swiftui/conditional-view-modifier/
    @ViewBuilder func `if`<Content: View>(
        _ condition: Bool,
        transform: (Self) -> Content
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
