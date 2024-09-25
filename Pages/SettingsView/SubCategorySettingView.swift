//
//  SubCategorySettingView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/15.
//

import Defaults
import SwiftUI
import TipKit

struct SubCategorySettingView: View {
	@EnvironmentObject var manager:peacock
    @Default(.Subcategorys) var items
    @Default(.Categorys) var categoryItems
    @Binding var columnVisibility: NavigationSplitViewVisibility
	@State private var selectedItem:SubCategoryData?
	
	@State private var scalId:String?
    var body: some View {
		ScrollViewReader { proxy in
			List(selection: $selectedItem) {
				
				ForEach($items, id: \.id){item in
					NavigationLink{
						ChangeSubcategoryView(item: item)
					}label: {
						HStack{
							
							Text("\(categoryTitle(id: item.categoryId.wrappedValue))")
							Spacer()
							Text("\(item.title.wrappedValue)")
							
							
						}
						.swipeActions(edge: .leading, allowsFullSwipe: true) {
							Button{
								// TODO: copy
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
					.id(item.id)
					
				}
				.onDelete(perform: manager.removeSubcategoryItems)
				.onMove(perform: { indices, newOffset in
					items.move(fromOffsets: indices, toOffset: newOffset)
				})
				
				
				
			}
			.toolbar{
				ToolbarItem {
					Button{
						let newItem = SubCategoryData.space()
						items.append(newItem)
						self.selectedItem = newItem
						self.scalId = newItem.id
							
						
					}label: {
						Image(systemName: "plus")
					}
				}
			}
			.onChange(of: scalId) { oldValue, newValue in
				withAnimation {
					proxy.scrollTo(newValue)
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
	let editTip = EditChangeTipView()
    var body: some View {
        
        Form{
			
			TipView(editTip)
			
            Section{
                
                Picker(selection: $item.categoryId, label: Text("选择项目大类")) {
                    ForEach(categoryItems, id: \.id ){item in
                        Text(item.title).tag(item.id)
                    }
                }
            }
            
            Section{
                TextField("项目小类", text: $item.title)
					.customField(icon: "pencil",data: $item.title)
            }header:{
                Text("项目小类")
            }
            Section{
                TextField("项目小类副标题", text: $item.subTitle)
					.customField(icon: "pencil",data: $item.subTitle)
            }header: {
                Text("项目小类副标题")
            }
            Section{
                TextField("项目小类底部", text: $item.footer)
					.customField(icon: "pencil",data:  $item.footer)
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
