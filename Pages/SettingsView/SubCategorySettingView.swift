//
//  SubCategorySettingView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/15.
//

import Defaults
import RealmSwift
import SwiftUI
import TipKit

struct SubCategorySettingView: View {
    @EnvironmentObject var manager: peacock
    
    @ObservedResults(
        CategoryRealmData.self,
        sortDescriptor: SortDescriptor(
            keyPath: \CategoryRealmData.sort,
            ascending: true
        )
    ) var categoryItems
    
    @ObservedResults(
        SubCategoryRealmData.self,
        sortDescriptor: SortDescriptor(
            keyPath: \SubCategoryRealmData.sort,
            ascending: true
        )
    ) var items
    @Binding var columnVisibility: NavigationSplitViewVisibility
    @State private var selectedItem: SubCategoryRealmData?

    @State private var scalID: String?
    var body: some View {
        ScrollViewReader { proxy in
            List(selection: $selectedItem) {
                ForEach(items, id: \.id) { item in
                    NavigationLink {
                        ChangeSubcategoryView(item: item)
                    } label: {
                        HStack {
                            Text("\(item.sort)")
                                .font(.title3.bold())
                            Text(verbatim: "-")
                            Text("\(categoryTitle(id: item.categoryID))")
                            Spacer()
                            Text("\(item.title)")
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            Button {
                                let data = item.copyID()
                                data.sort += 1
                                $items.append(data)
                                self.selectedItem = data
                                self.scalID = data.id
                            } label: {
                                Text("复制")
                            }
                        }
                    }
                    .listRowSpacing(30)
                    .tag(item)
                    .id(item.id)
                }
                .onDelete { indexSet in
                    do {
                        guard let index = indexSet.first else { return }
                        let data = items[index]
                        let realm = try Realm()
                        let subcategorys = realm.objects(SubCategoryRealmData.self)
                            .where { $0.id == data.id }
                        let items = realm.objects(ItemRealmData.self)
                            .where { $0.subcategoryID == data.id }
                        try realm.write {
                            realm.delete(subcategorys)
                            realm.delete(items)
                        }
                    } catch {
                        debugPrint(error.localizedDescription)
                    }
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .toolbar {
                ToolbarItem {
                    Button {
                        let data = SubCategoryRealmData.create()
                        $items.append(data)
                        self.selectedItem = data
                        self.scalID = data.id

                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .onChange(of: scalID) { _, newValue in
                withAnimation {
                    proxy.scrollTo(newValue)
                }
            }
        }
    }

    func categoryTitle(id: String) -> String {
        if let category = categoryItems.first(where: { $0.id == id }) {
            return category.title
        }
        return "未知"
    }
}

struct ChangeSubcategoryView: View {
    @ObservedRealmObject var item: SubCategoryRealmData
    @ObservedResults(
        CategoryRealmData.self,
        sortDescriptor: SortDescriptor(
            keyPath: \CategoryRealmData.sort,
            ascending: true
        )
    ) var categoryItems
    let editTip = EditChangeTipView()
    var body: some View {
        Form {
            TipView(editTip)

            Section {
                Picker(selection: $item.categoryID, label: Text("选择项目大类")) {
                    ForEach(categoryItems, id: \.id) { item in
                        Text(item.title).tag(item.id)
                    }
                }
            }

            Section {
                TextField("项目排序", value: $item.sort, formatter: NumberFormatter())
                    .customField(icon: "pencil", data: $item.sort)
                    .keyboardType(.numberPad)
            } header: {
                Text("排序")
            }

            Section {
                TextField("项目小类", text: $item.title)
                    .customField(icon: "pencil", data: $item.title)
            } header: {
                Text("项目小类")
            }
            Section {
                TextField("项目小类副标题", text: $item.subTitle)
                    .customField(icon: "pencil", data: $item.subTitle)
            } header: {
                Text("项目小类副标题")
            }
            Section {
                TextField("项目小类底部", text: $item.footer)
                    .customField(icon: "pencil", data: $item.footer)
            } header: {
                Text("项目小类底部")
            }
        }
    }
}

#Preview {
    SubCategorySettingView(columnVisibility: .constant(.all))
        .environmentObject(peacock.shared)
}
