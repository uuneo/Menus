//
//  SubCategorySettingView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/15.
//

import Defaults
import SwiftUI

struct SubCategorySettingView: View {
	@EnvironmentObject var manager:peacock
    @Default(.Subcategorys) var items
    @Default(.Categorys) var categoryItems
    @Binding var columnVisibility: NavigationSplitViewVisibility
	@State private var selectedItem:SubCategoryData?
    var body: some View {
		List(selection: $selectedItem) {
            ForEach($items, id: \.id){item in
                NavigationLink{
                    ChangeSubcategoryView(item: item)
                }label: {
                    HStack{
                        Text("\(item.title.wrappedValue)")
                        Spacer()
                        Text("\(categoryTitle(id: item.categoryId.wrappedValue))")
                    }
					.swipeActions(edge: .leading, allowsFullSwipe: true) {
						Button{
							// TODO: 删除
							if let index = items.firstIndex(where: {$0 == item.wrappedValue}){
								let newItem = item.wrappedValue.copy()
								items.insert(newItem,at: index)
								self.selectedItem = newItem
							}
							
						}label: {
							Text("复制")
						}
					}
                    
                }
                .listRowSpacing(30)
				.tag(item.wrappedValue)
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
					let item = SubCategoryData.space()
                    items.insert(item, at: 0)
					self.selectedItem = item
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
                    .customField(icon: "pencil")
            }header:{
                Text("项目小类")
            }
            Section{
                TextField("项目小类副标题", text: $item.subTitle)
                    .customField(icon: "pencil")
            }header: {
                Text("项目小类副标题")
            }
            Section{
                TextField("项目小类底部", text: $item.footer)
                    .customField(icon: "pencil")
            }header: {
                Text("项目小类底部")
            }
        }
    }
}

#Preview {
    SubCategorySettingView(columnVisibility: .constant(.all))
		.environmentObject(peacock.shared)
}
