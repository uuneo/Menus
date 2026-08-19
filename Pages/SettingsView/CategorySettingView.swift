//
//  CategorySettingView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/15.
//

import Defaults
import RealmSwift
import SwiftUI
import TipKit

struct CategorySettingView: View {
    @EnvironmentObject var manager: peacock
    

    @ObservedResults(
        CategoryRealmData.self,
        sortDescriptor: SortDescriptor(
            keyPath: \CategoryRealmData.sort,
            ascending: true
        )
    ) var items
    
    @Binding var columnVisibility: NavigationSplitViewVisibility
    var body: some View {
        List {
            ForEach(items, id: \.id) { item in
                NavigationLink {
                    ChangeCategoryView(item: item)
                } label: {
                    LabeledContent {
                        Image(systemName: "pencil")
                    } label: {
                        HStack {
                            Text(verbatim: "\(item.sort)")
                                .font(.title3.bold())
                            Text(verbatim: "-")
                            Text(verbatim: "\(item.title)")
                            Spacer()
                        }
                    }
                }
            }
            .onDelete { indexSet in
                do {
                    guard let index = indexSet.first else { return }
                    let data = items[index]
                    let realm = try Realm()
                    let categorys = realm.objects(CategoryRealmData.self).where { $0.id == data.id }
                    let subcategorys = realm.objects(SubCategoryRealmData.self)
                        .where { $0.categoryID == data.id }
                    let items = realm.objects(ItemRealmData.self).where { $0.categoryID == data.id }
                    try realm.write {
                        realm.delete(categorys)
                        realm.delete(subcategorys)
                        realm.delete(items)
                    }
                } catch {
                    debugPrint(error.localizedDescription)
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollDismissesKeyboard(.interactively)
        .toolbar {
            ToolbarItem {
                Button {
                    $items.append(CategoryRealmData.create())
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

struct ChangeCategoryView: View {
    @ObservedRealmObject var item: CategoryRealmData
//    @Binding var item:CategoryData
    @Environment(\.dismiss) var dismiss
    let editTip = EditChangeTipView()

    var body: some View {
        Form {
            TipView(editTip)

            Section {
                TextField("项目排序", value: $item.sort, formatter: NumberFormatter())
                    .customField(icon: "pencil", data: $item.sort)
                    .keyboardType(.numberPad)
            } header: {
                Text("排序")
            }

            Section {
                TextField("项目大类", text: $item.title)
                    .customField(icon: "pencil", data: $item.title)
            } header: {
                Text("分类标题")
            }
            Section {
                TextField("项目副标题", text: $item.subTitle)
                    .customField(icon: "pencil", data: $item.subTitle)
            } header: {
                Text("项目副标题")
            }
            Section {
                TextField("项目图片", text: $item.image)
                    .customField(icon: "pencil", data: $item.image)
            } header: {
                Text("项目图片")
            }
            Section {
                ColorPicker("选择/输入背景颜色", selection: Binding(get: {
                    Color(from: item.color)
                }, set: { value in
                    if let value = value.toHex() {
                        do {
                            if let thrw = item.thaw() {
                                let realm = try Realm()
                                try realm.write {
                                    thrw.color = value
                                }
                            }
                        } catch {
                            debugPrint(error.localizedDescription)
                        }
                    }

                }))

                TextField("项目颜色", text: $item.color)
                    .customField(icon: "pencil", data: $item.color)
            } header: {
                Text("背景颜色")
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle("修改数据")
    }
}

#Preview {
    NavigationStack {
        CategorySettingView(columnVisibility: .constant(.all))
            .environmentObject(peacock.shared)
    }
}
