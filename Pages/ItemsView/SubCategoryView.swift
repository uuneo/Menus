//
//  SubCategoryView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/14.
//

import Defaults
import RealmSwift
import SwiftUI

struct SubCategoryView: View {
    @ObservedRealmObject var subcategory: SubCategoryRealmData

    @ObservedResults(ItemRealmData.self, sortDescriptor: SortDescriptor(
        keyPath: \ItemRealmData.sort, ascending: true
    )) var items

    var projectItems: [ItemRealmData] {
        items.filter { $0.subcategoryID == subcategory.id }
    }

    // 瀑布流: 卡片最小宽度约 300, 宽屏自动多列
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // MARK: 分类标题 + 副标题
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 10) {
                    Text(subcategory.title)
                        .font(.title2.bold())
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)

                    if !subcategory.footer.isEmpty {
                        Text(subcategory.footer)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }

                    Spacer(minLength: 0)
                }

                if !subcategory.subTitle.isEmpty {
                    Text(subcategory.subTitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
            }
            .padding(.horizontal, ISPAD ? 40 : 20)

            // 标题下细分隔线
            Rectangle()
                .fill(Color.primary.opacity(0.08))
                .frame(height: 1)
                .padding(.horizontal, ISPAD ? 40 : 20)

            // MARK: 瀑布流卡片
            MasonryLayout(minimum: 300, spacing: 14) {
                ForEach(projectItems, id: \.id) { item in
                    ProjectCardView(data: item, show: .constant(true))
                        .scrollTransition { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1 : 0)
                                .scaleEffect(phase.isIdentity ? 1 : 0.92)
                                .blur(radius: phase.isIdentity ? 0 : 6)
                        }
                }
            }
            .padding(.horizontal, ISPAD ? 40 : 20)
            .padding(.bottom, 24)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

enum showType {
    case all
    case base
    case course
}
