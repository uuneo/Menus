//
//   ProjectSettingView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/15.
//

import Defaults
import RealmSwift
import SwiftUI
import TipKit

struct ProjectSettingView: View {
   @State private var manager = peacock.shared

    @ObservedResults(
        ItemRealmData.self,
        sortDescriptor: SortDescriptor(
            keyPath: \ItemRealmData.sort,
            ascending: true
        )
    ) var items

    @ObservedResults(
        SubCategoryRealmData.self,
        sortDescriptor: SortDescriptor(
            keyPath: \SubCategoryRealmData.sort,
            ascending: true
        )
    ) var subcategoryItems
    
    @ObservedResults(
        CategoryRealmData.self,
        sortDescriptor: SortDescriptor(
            keyPath: \CategoryRealmData.sort,
            ascending: true
        )
    ) var categoryItems
    @Binding var columnVisibility: NavigationSplitViewVisibility
    @State private var searchText: String = ""

    @State private var selectItem: ItemRealmData?

    @State private var scalID: String?

    var body: some View {
        ScrollViewReader { proxy in
            List(selection: $selectItem) {
                ForEach(items, id: \.id) { item in
                    NavigationLink {
                        ChangeSubCategoryView(item: item)
                    } label: {
                        HStack {
                            Text("\(item.sort)")
                                .font(.title3.bold())
                            Text("-")
                            Text(subcategoryTitle(item: item))
                            Spacer()
                            Text("\(item.title)")
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            Button {
                                let data = item.copyID()
                                data.sort += 1
                                $items.append(data)
                                self.scalID = data.id
                                self.selectItem = data

                            } label: {
                                Text("复制")
                            }
                        }
                    }
                    .tag(item)
                    .id(item.id)
                }

                .onDelete(perform: $items.remove)
            }
            .scrollDismissesKeyboard(.interactively)
            .searchable(text: $searchText, prompt: "搜索数据")
            .toolbar {
                ToolbarItem {
                    Button {
                        let data = ItemRealmData.create()
                        $items.append(data)
                        self.scalID = data.id
                        self.selectItem = data

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

    func subcategoryTitle(item: ItemRealmData) -> String {
        guard let subcategory = subcategoryItems.first(where: { $0.id == item.subcategoryID }),
              let category = categoryItems.first(where: { $0.id == item.categoryID })
        else {
            return "未知"
        }
        return "\(category.title)-\(subcategory.title)"
    }
}

struct ChangeSubCategoryView: View {
    @ObservedRealmObject var item: ItemRealmData
    @ObservedResults(
        SubCategoryRealmData.self,
        sortDescriptor: SortDescriptor(
            keyPath: \SubCategoryRealmData.sort,
            ascending: true
        )
    ) var subcategoryItems
    @ObservedResults(
        CategoryRealmData.self,
        sortDescriptor: SortDescriptor(
            keyPath: \CategoryRealmData.sort,
            ascending: true
        )
    ) var categoryItems

    var body: some View {
        Form {
            Section {
                Picker(selection: $item.categoryID) {
                    ForEach(categoryItems, id: \.id) { data in
                        Text(data.title)
                            .tag(data.id)
                    }
                } label: {
                    Text("选择项目大类")
                }
            }
            .onChange(of: item.categoryID) { _, _ in
                if let thaw = item.thaw() {
                    if let subcategory = subcategoryItems
                        .first(where: { $0.categoryID == item.categoryID })
                    {
                        if let realm = try? Realm() {
                            try? realm.write {
                                thaw.subcategoryID = subcategory.id
                            }
                        }
                    }
                }
            }

            Section {
                Picker(selection: $item.subcategoryID) {
                    ForEach(
                        subcategoryItems.filter { $0.categoryID == item.categoryID },
                        id: \.id
                    ) { data in
                        Text(data.title)
                            .tag(data.id)
                    }
                } label: {
                    Text("选择项目小类")
                }
            }

            Section {
                HStack{
                    TextField("项目排序", value: $item.sort, format: .number)
                        .customField(icon: "pencil", data: $item.sort)
                        .keyboardType(.numberPad)
                    Spacer(minLength: 0)
                    Stepper(value: $item.sort, label: {})
                }
            } header: {
                Text("排序")
            }

            Section {
                TextField("项目名称", text: $item.title)
                    .customField(icon: "pencil", data: $item.title)

            } header: {
                Text("项目名称")
            }

            Section {
                TextField("项目副标题", text: $item.subTitle)
                    .customField(icon: "pencil", data: $item.subTitle)
            } header: {
                Text("项目副标题")
            }

            Section {
                TextField("项目小类别", text: $item.header)
                    .customField(icon: "pencil", data: $item.header)
            } header: {
                Text("项目小类别")
            }

            ForEach($item.prices, id: \.id) { $price in
                Section {
                    VStack {
                        TextField("价格", value: $price.money, format: .number)
                            .customField(icon: "pencil", title: "价格", data: $price.money)
                            .keyboardType(.numberPad)
                        
                        TextField("前缀", text: $price.prefix)
                            .customField(icon: "pencil", title: "前缀", data: $price.prefix)

                        TextField("后缀", text: $price.suffix)
                            .customField(icon: "pencil", title: "后缀", data: $price.suffix)

                        Toggle("是否打折", isOn: $price.discount)
                    }

                } header: {
                    HStack {
                        Text("价格类型: ")
                        Spacer()
                        Picker(selection: $price.mode) {
                            ForEach(PriceTypeEnum.allCases, id: \.self) { mode in
                                Text("\(mode.rawValue)").tag(mode)
                            }

                        } label: {
                            Text("价格\(price.mode.rawValue)")
                        }
                        .pickerStyle(.palette)
                        .padding()
                        .accentColor(.white)
                    }
                }
            }.onDelete(perform: $item.prices.remove)

            if item.prices.count < 4 {
                Button {
                    $item.prices.append(PriceRealmData())
                } label: {
                    Label {
                        Text("添加价格")
                    } icon: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

#Preview {
    ProjectSettingView(columnVisibility: .constant(.all))
        
}
