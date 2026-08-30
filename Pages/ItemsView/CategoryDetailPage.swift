//
//  CategoryDetailPage.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/13.
//

import Defaults
import RealmSwift
import SwiftUI
import TipKit

struct CategoryDetailPage: View {
   @State private var manager = peacock.shared
    var selectedItem: CategoryRealmData
    var namespace: Namespace.ID
    @State private var progress: CGFloat = 1
    @State private var isScrolling: Bool = false

    var columns = Array(repeating: GridItem(.flexible(), spacing: 30), count: 3)

//    @Default(.Subcategorys) var subcategoryItems
    @ObservedResults(SubCategoryRealmData.self, sortDescriptor: SortDescriptor(
        keyPath: \SubCategoryRealmData.sort, ascending: true
    )) var subcategoryItems

//    @Default(.Items) var items
    @ObservedResults(ItemRealmData.self, sortDescriptor: SortDescriptor(
        keyPath: \ItemRealmData.sort, ascending: true
    )) var items

    var selectItems: [SubCategoryRealmData] {
        return subcategoryItems.filter { $0.categoryID == selectedItem.id }
    }

    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 0) {
            // 顶部彩色 header
            headerContent
                .padding(.horizontal, 12)
                .frame(height: 110)
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(
                        colors: [categoryColor, categoryColor.opacity(0.85)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .ignoresSafeArea(edges: .top)
                .matchedTransitionSource(id: selectedItem.id, in: namespace)

            // 下方渐变圆角面板承载列表
            ScrollView {
                LazyVStack {
                    ForEach(selectItems, id: \.id) { item in
                        if items.filter({ $0.subcategoryID == item.id }).count > 0 {
                            SubCategoryView(subcategory: item)
                        }
                    }

                    if selectItems.count > 1 {
                        Spacer(minLength: 200)
                    }
                }
                .padding(.top, 16)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                UnevenRoundedRectangle(
                    cornerRadii: .init(topLeading: 28, topTrailing: 28)
                )
                .fill(.ultraThinMaterial)
                .ignoresSafeArea(edges: .bottom)
            )
        }
        .background(
            LinearGradient(
                colors: [categoryColor, categoryColor.opacity(0.55)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }

    private var categoryColor: Color {
        Color(from: selectedItem.color)
    }

    @ViewBuilder
    private var headerContent: some View {
        if ISPAD {
            ipadHeader()
        } else {
            iphoneHeader()
        }
    }

    private func ipadHeader() -> some View {
        ZStack {
            HStack {
                VStack {
                    Spacer()
                    Button {
                        withAnimation(.spring(
                            response: 0.5,
                            dampingFraction: 0.8,
                            blendDuration: 0.8
                        )) {
                            self.dismiss()
                        }

                    } label: {
                        Image(systemName: "house.circle")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding()
                    }
                }

                VStack(alignment: .leading) {
                    Spacer()

                    Text(selectedItem.title)
                        .font(.largeTitle)
                        .bold()
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)

                    Text(selectedItem.subTitle)
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.9))
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                }
                .foregroundColor(.white)
                .frame(minWidth: 200)
                .layoutPriority(1)
                .padding(.vertical)
                Spacer()

                VStack {
                    Spacer()
                    PickerOfCardView()
                }

                VStack {
                    Spacer()
                    AsyncImageView(imageURL: selectedItem.image)
                        .scaledToFit()
                        .frame(width: 200)
                        .padding(.trailing, 100)
                }
            }
            .opacity(1 - progress)

            VStack {
                Spacer()
                HStack {
                    Button {
                        withAnimation(.spring(
                            response: 0.5,
                            dampingFraction: 0.8,
                            blendDuration: 0.8
                        )) {
                            self.dismiss()
                        }

                    } label: {
                        Image(systemName: "chevron.left.2")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                    }

                    Spacer()

                    AsyncImageView(imageURL: selectedItem.image)
                        .scaledToFit()
                        .frame(width: 50)
                        .padding(.horizontal)

                    Text(selectedItem.title)
                        .font(.title3)
                        .bold()
                        .foregroundColor(.white)
                        .lineLimit(1)

                    Text(selectedItem.subTitle)
                        .lineLimit(1)
                        .foregroundColor(.white)

                    PickerOfCardView()

                    Spacer()
                }
            }
            .opacity(progress)
            .opacity(max(0, min(1, (progress - 0.75) * 4.0)))
        }
    }

    private func iphoneHeader() -> some View {
        ZStack {
            ZStack {
                VStack {
                    Spacer()
                    HStack(alignment: .bottom) {
                        Button {
                            withAnimation(.spring(
                                response: 0.5,
                                dampingFraction: 0.8,
                                blendDuration: 0.8
                            )) {
                                self.dismiss()
                            }

                        } label: {
                            Image(systemName: "chevron.left.2")
                                .font(.title)
                                .foregroundColor(.white)
                        }

                        VStack(alignment: .leading) {
                            Text(selectedItem.title)
                                .font(.title)
                                .bold()
                                .minimumScaleFactor(0.5)

                            Text(selectedItem.subTitle)
                                .minimumScaleFactor(0.5)
                        }
                        .foregroundColor(.white)

                        Spacer()
                    }
                }

                VStack {
                    HStack {
                        Spacer()
                        PickerOfCardView()
                            .padding(.top, 30)
                    }
                    Spacer()
                }

                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        AsyncImageView(imageURL: selectedItem.image)
                            .scaledToFit()
                            .frame(width: 100)
                            .padding(.trailing, 10)
                    }
                }
            }
            .padding(10)
            .opacity(1 - progress)

            VStack {
                Spacer()
                HStack {
                    Button {
                        withAnimation(.spring(
                            response: 0.5,
                            dampingFraction: 0.8,
                            blendDuration: 0.8
                        )) {
                            self.dismiss()
                        }

                    } label: {
                        Image(systemName: "chevron.left.2")
                            .font(.title2)
                            .foregroundColor(.white)
                    }

                    VStack(alignment: .leading) {
                        Text(selectedItem.title)
                            .font(.title3)
                            .bold()
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)

                        Text(selectedItem.subTitle)
                            .lineLimit(1)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                            .minimumScaleFactor(0.5)
                    }
                    .layoutPriority(1)
                    Spacer()

                    PickerOfCardView()
                        .layoutPriority(-1)

                }.padding(.horizontal, 10)
            }
            .opacity(progress)
            .opacity(max(0, min(1, (progress - 0.75) * 4.0)))
        }
    }
}

struct PickerOfCardView: View {
   @State private var manager = peacock.shared
    @ObservedResults(MemberCardRealmData.self, sortDescriptor: SortDescriptor(
        keyPath: \MemberCardRealmData.sort, ascending: true
    )) var cards

    var pickers: [MemberCardRealmData] {
        [MemberCardRealmData.nonmember] + Array(cards)
    }

    var body: some View {
        Picker(selection: $manager.selectCard) {
            ForEach(pickers, id: \.id) { card in
                Text("\(card.title)\(card.name)")
                    .tag(card.id)
            }
        } label: {
            Text("选择卡片")
        }
        .padding()
        .accentColor(.white)
    }
}

#Preview {
    @Previewable @Namespace var ns
    CategoryDetailPage(selectedItem: CategoryRealmData(), namespace: ns)

}
