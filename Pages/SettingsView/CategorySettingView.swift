//
//  CategorySettingView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/15.
//

import SwiftUI
import Defaults

struct CategorySettingView: View {
    @StateObject var manager = peacock.shared
    @Default(.Categorys) var items
    @Binding var columnVisibility: NavigationSplitViewVisibility
    var body: some View {
        List {
            ForEach($items, id: \.id){ item in
                NavigationLink {
                    ChangeCategoryView(item: item)
                } label: {
                    
                    LabeledContent {
                        Image(systemName: "pencil")
                    } label: {
                        Label("\(item.title.wrappedValue)", systemImage: "pencil")
                    }
                    
                }
                
            }
            .onDelete(perform:  manager.removeCategoryItems)
            .onMove(perform: { indices, newOffset in
                items.move(fromOffsets: indices, toOffset: newOffset)
            })
            
            
        } .listStyle(.insetGrouped)
            .toolbar{
                ToolbarItem {
                    Button{
                        createNewCategory()
                    }label: {
                        Image(systemName: "plus")
                    }
                }
            }
    }
    func createNewCategory(){
        items.insert(CategoryData.space(), at: 0)
    }
}




struct ChangeCategoryView: View {
    @Binding var item:CategoryData
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            
            Section{
                TextField("项目大类", text: $item.title)
                    .customField(icon: "pencil")
            }header: {
                Text("分类标题")
            }
            Section {
                TextField("项目副标题", text: $item.subTitle)
                    .customField(icon: "pencil")
            }header: {
                Text("项目副标题")
            }
            Section {
                TextField("项目图片", text: $item.image)
                    .customField(icon: "pencil")
            }header: {
                Text("项目图片")
            }
            Section {
                TextField("项目颜色", text: $item.color)
                    .customField(icon: "pencil")
            }header: {
                Text("背景颜色")
            }
        }
        
        .navigationTitle("修改数据")
        
    }
}



#Preview {
    NavigationStack {
                CategorySettingView(columnVisibility: .constant(.all))
//        ChangeCategoryView(item: .constant(CategoryData.example))
    }
    
}
