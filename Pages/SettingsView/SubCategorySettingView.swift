//
//  SubCategorySettingView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/15.
//

import Defaults
import SwiftUI

struct SubCategorySettingView: View {
    @StateObject var manager = peacock.shared
    @Default(.Subcategorys) var items
    @Default(.Categorys) var categoryItems
    @Binding var columnVisibility: NavigationSplitViewVisibility
    var body: some View {
        List {
            ForEach($items, id: \.id){item in
                NavigationLink{
                    ChangeSubcategoryView(item: item)
                }label: {
                    HStack{
                        Text("\(item.title.wrappedValue)")
                        Spacer()
                        Text("\(categoryTitle(id: item.categoryId.wrappedValue))")
                    }
                    
                }
                .listRowSpacing(30)
            }
            .onDelete(perform: manager.removeSubcategoryItems)
            .onMove(perform: { indices, newOffset in
                items.move(fromOffsets: indices, toOffset: newOffset)
            })
            
        }
        .listStyle(.insetGrouped)
        .toolbar{
            ToolbarItem {
                Button{
                    items.append(SubCategoryData.space())
                }label: {
                    Image(systemName: "plus")
                }
            }
        }
       
    }
    
    func categoryTitle(id:String)->String{
        
        if let category =  categoryItems.first(where: {$0.id == id}){
            return category.title
        }
        return "未知"
    }

    
}

struct ChangeSubcategoryView:View {
    @Binding var item:SubCategoryData
    @Default(.Categorys) var categoryItems

    var body: some View {
        
        Form{
            Section{
                
                Picker(selection: $item.categoryId, label: Text("选择项目大类")) {
                    ForEach(categoryItems, id: \.id ){item in
                        Text(item.title).tag(item.id)
                    }
                }
            }
            
            Section{
                TextField("项目小类", text: $item.title)
                    .customTitleField(icon: "pencil")
            }header:{
                Text("项目小类")
            }
            Section{
                TextField("项目小类副标题", text: $item.subTitle)
                    .customTitleField(icon: "pencil")
            }header: {
                Text("项目小类副标题")
            }
            Section{
                TextField("项目小类底部", text: $item.footer)
                    .customTitleField(icon: "pencil")
            }header: {
                Text("项目小类底部")
            }
        }
    }
}

#Preview {
    SubCategorySettingView(columnVisibility: .constant(.all))
}
