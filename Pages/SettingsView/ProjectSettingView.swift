//
//   ProjectSettingView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/15.
//

import SwiftUI
import Defaults

struct ProjectSettingView: View {
    @StateObject var manager = peacock.shared
    @Default(.items) var items
    @Default(.subcategoryItems) var subcategoryItems
    @Default(.categoryItems) var categoryItems
    @Binding var columnVisibility: NavigationSplitViewVisibility
    var body: some View {
        List {
           
            ForEach($items,id: \.id){item in
                
                Section {
                    NavigationLink{
                        ChangeItemView(item: item)
                    }label: {
                        HStack{
                            Text("\(item.title.wrappedValue)")
                            Spacer()
                            Text(subcategoryTitle(id: item.subcategoryId.wrappedValue))
                        }
                    }
                }
                
               
                
            }
            .onDelete(perform: manager.removeItems)
            .onMove(perform: { indices, newOffset in
                items.move(fromOffsets: indices, toOffset: newOffset)
            })
        }
        .toolbar{
            ToolbarItem {
                Button{
                    items.append(itemData.space())
                }label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
    func subcategoryTitle(id:String)->String{
        guard let subcategory = subcategoryItems.first(where: {$0.id == id}),
              let category = categoryItems.first(where: {$0.id == subcategory.categoryId})
        else{
            return "未知"
        }
        return "\(category.title)-\(subcategory.title)"
    }
}

struct ChangeItemView:View {
    @Binding var item:itemData
    @Default(.subcategoryItems) var subcategoryItems
    @Default(.categoryItems) var categoryItems
   
    var body: some View {

        Form{
            Section{
                Picker(selection: $item.subcategoryId) {
                    ForEach($subcategoryItems , id: \.id){ data in
                        Text(subcategoryTitle(id: data.id))
                            .tag(data.id)
                        
                    }
                } label: {
                    Text("选择项目分类")
                }

            }
            
            
            Section{
                TextField("项目名称", text: $item.title)
                    .customTitleField(icon: "pencil",title: "项目名称")
                TextField("项目副标题", text: $item.subTitle)
                    .customTitleField(icon: "pencil",title: "项目副标题")
                
            }
            
            Section{
                
                TextField("价格1", value: $item.price1.money, formatter: NumberFormatter())
                    .customTitleField(icon: "pencil",title: "价格1")
                
                TextField("前缀", text: $item.price1.prefix)
                    .customTitleField(icon: "pencil",title: "前缀")
                
                
                TextField("后缀", text: $item.price1.suffix)
                    .customTitleField(icon: "pencil",title: "后缀")
                
                Toggle("是否打折", isOn: $item.price1.discount)
                
            }
            
            Section{
                TextField("价格2", value: $item.price2.money, formatter: NumberFormatter())
                    .customTitleField(icon: "pencil",title: "价格1")
                
                TextField("前缀", text: $item.price2.prefix)
                    .customTitleField(icon: "pencil",title: "前缀")
                
               
                TextField("后缀", text: $item.price2.suffix)
                    .customTitleField(icon: "pencil",title: "后缀")
                
                Toggle("是否打折", isOn: $item.price2.discount)
                
            }
            
            Section{
                
                TextField("价格3", value: $item.price3.money, formatter: NumberFormatter())
                    .customTitleField(icon: "pencil",title: "价格1")
                
                TextField("前缀", text: $item.price3.prefix)
                    .customTitleField(icon: "pencil",title: "前缀")
                
                TextField("后缀", text: $item.price3.suffix)
                    .customTitleField(icon: "pencil",title: "后缀")
                
                Toggle("是否打折", isOn: $item.price3.discount)
                
            }
            
            Section{
                
                TextField("价格4", value: $item.price4.money, formatter: NumberFormatter())
                    .customTitleField(icon: "pencil",title: "价格1")
                
                TextField("前缀", text: $item.price4.prefix)
                    .customTitleField(icon: "pencil",title: "前缀")
                
                TextField("后缀", text: $item.price4.suffix)
                    .customTitleField(icon: "pencil",title: "后缀")
                
                Toggle("是否打折", isOn: $item.price4.discount)
                
            }
        }
    }
    func subcategoryTitle(id:String)->String{
        guard let subcategory = subcategoryItems.first(where: {$0.id == id}),
              let category = categoryItems.first(where: {$0.id == subcategory.categoryId})
        else{
            return "未知"
        }
        return "\(category.title)-\(subcategory.title)"
    }
}

#Preview {
    ProjectSettingView(columnVisibility: .constant(.all))
}
