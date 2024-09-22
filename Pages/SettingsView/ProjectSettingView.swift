//
//   ProjectSettingView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/15.
//

import SwiftUI
import Defaults

struct ProjectSettingView: View {
	@EnvironmentObject var manager:peacock
    @Default(.Items) var items
    @Default(.Subcategorys) var subcategoryItems
    @Default(.Categorys) var categoryItems
    @Binding var columnVisibility: NavigationSplitViewVisibility
    @State private var searchText:String = ""
	
	@State private var selectItem:ItemData?
    
    var filterItems:[ItemData]{
        let itemsData = items.filter({$0.title.contains(searchText)})
        return itemsData.count == 0 ?  items : itemsData
    }
    
    
    var body: some View {
		List(selection: $selectItem ) {
            if items.filter({$0.title.contains(searchText)}).count == 0{
                ForEach($items,id: \.id){item in
                    
                    
                    NavigationLink{
                        ChangeItemView(item: item)
                    }label: {
                        HStack{
							Text(subcategoryTitle(item: item.wrappedValue))
                            Spacer()
							Text("\(item.title.wrappedValue)")
                        }
						.swipeActions(edge: .leading, allowsFullSwipe: true) {
							Button{
								// TODO: 删除
								if let index = items.firstIndex(where: {$0 == item.wrappedValue}){
									let newItem = item.wrappedValue.copy()
									items.insert(newItem,at: index)
									self.selectItem = newItem
								}
								
							}label: {
								Text("复制")
							}
						}
                    }
					.tag(item.wrappedValue)
                }
				
                .onDelete(perform: manager.removeItems)
                .onMove { indexSet, number in
                    items.move(fromOffsets: indexSet, toOffset: number)
                }
				
            
            }else{
                ForEach(filterItems,id: \.id){item in
                    NavigationLink{
                        ChangeItemView(item: Binding(get: { item }, set: { value in
                            Defaults[.Items].firstIndex(where: {$0.id == item.id}).map{
                                Defaults[.Items][$0] = value
                            }
                        }))
                    }label: {
                        HStack{
                            Text("\(item.title)")
                            Spacer()
                            Text(subcategoryTitle(item: item))
                        }
                    }
                } .onDelete(perform: manager.removeItems)
                   
            }
            
           
               
          
           
          
        }
        .searchable(text: $searchText,prompt: "搜索数据")
        .toolbar{
            ToolbarItem {
                Button{
                    items.insert(ItemData.space(), at: 0)
                   
                }label: {
                    Image(systemName: "plus")
                }
            }
            
           
        }
    }
    func subcategoryTitle(item:ItemData)->String{
        guard let subcategory = subcategoryItems.first(where: {$0.id == item.subcategoryId}),
              let category = categoryItems.first(where: {$0.id == item.categoryId})
        else{
            return "未知"
        }
        return "\(category.title)-\(subcategory.title)"
    }
    
    
}

struct ChangeItemView:View {
    @Binding var item:ItemData
    @Default(.Subcategorys) var subcategoryItems
    @Default(.Categorys) var categoryItems
   
    var body: some View {

        Form{
            
            
            Section{
                Picker(selection: $item.categoryId) {
                    ForEach($categoryItems , id: \.id){ data in
                        Text(data.title.wrappedValue)
                            .tag(data.id)
                        
                    }
                } label: {
                    Text("选择项目大类")
                }

            }.onChange(of: item.categoryId) { oldValue, newValue in
                let subcategory = subcategoryItems.first(where: {$0.categoryId == item.categoryId})
                item.subcategoryId = subcategory?.id ?? UUID().uuidString
            }
            
            
            
            Section{
                Picker(selection: $item.subcategoryId) {
                   
                    ForEach( subcategoryItems.filter({$0.categoryId == item.categoryId}) , id: \.id){ data in
                        Text(data.title)
                            .tag(data.id)
                        
                    }
                } label: {
                    Text("选择项目小类")
                }

            }
            
            
            
            
            
            
            
            
            
            
            
            
            
            Section{
                TextField("项目名称", text: $item.title)
                    .customField(icon: "pencil")
               
            }header: {
                Text("项目名称")
            }
            
            Section{
                TextField("项目副标题", text: $item.subTitle)
                    .customField(icon: "pencil")
            }header: {
                Text("项目副标题")
            }
            
            
            Section{
                TextField("项目小类别", text: $item.header)
                    .customField(icon: "pencil")
            }header: {
                Text("项目小类别")
            }
            
            
            
            
            Section{
                
                TextField("价格", value: $item.price1.money, formatter: NumberFormatter())
                    .customField(icon: "pencil",title: "价格")
                
                TextField("前缀", text: $item.price1.prefix)
                    .customField(icon: "pencil",title: "前缀")
                
                
                TextField("后缀", text: $item.price1.suffix)
                    .customField(icon: "pencil",title: "后缀")
                
                Toggle("是否打折", isOn: $item.price1.discount)
                
            }header: {
                Text("价格1")
            }
            
            Section{
                TextField("价格", value: $item.price2.money, formatter: NumberFormatter())
                    .customField(icon: "pencil",title: "价格")
                
                TextField("前缀", text: $item.price2.prefix)
                    .customField(icon: "pencil",title: "前缀")
                
               
                TextField("后缀", text: $item.price2.suffix)
                    .customField(icon: "pencil",title: "后缀")
                
                Toggle("是否打折", isOn: $item.price2.discount)
                
            }header: {
                Text("价格2")
            }
            
            Section{
                
                TextField("价格", value: $item.price3.money, formatter: NumberFormatter())
                    .customField(icon: "pencil",title: "价格")
                
                TextField("前缀", text: $item.price3.prefix)
                    .customField(icon: "pencil",title: "前缀")
                
                TextField("后缀", text: $item.price3.suffix)
                    .customField(icon: "pencil",title: "后缀")
                
                Toggle("是否打折", isOn: $item.price3.discount)
                
            }header: {
                Text("价格3")
            }
            
            Section{
                
                TextField("价格", value: $item.price4.money, formatter: NumberFormatter())
                    .customField(icon: "pencil",title: "价格")
                
                TextField("前缀", text: $item.price4.prefix)
                    .customField(icon: "pencil",title: "前缀")
                
                TextField("后缀", text: $item.price4.suffix)
                    .customField(icon: "pencil",title: "后缀")
                
                Toggle("是否打折", isOn: $item.price4.discount)
                
            }header: {
                Text("价格4")
            }
        }
    }
}

#Preview {
    ProjectSettingView(columnVisibility: .constant(.all))
		.environmentObject(peacock.shared)
}
