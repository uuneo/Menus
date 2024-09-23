//
//  SettingsView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/8.
//

import SwiftUI
import Defaults


struct SettingsView: View {
	@EnvironmentObject var manager:peacock
    @Default(.settingPassword) var settingPassword
    @Default(.autoSetting) var autoSetting
    @State private var changeTitle:Bool = false
    
    @State private var selectedTab:Int? = 0
    
    @State private var columnVisibility: NavigationSplitViewVisibility = .automatic
    
	@State private var uploadProgress:Bool  = false
  
    var body: some View {
      


        
        NavigationSplitView(columnVisibility: $columnVisibility, preferredCompactColumn: .constant(.detail))  {
            
                
                List(selection: $selectedTab){
                    
                    Section {
                        
                    }header: {
                        Text("右滑返回")
                    }
                    
                    NavigationLink{
                        BasicSettingsView(columnVisibility: $columnVisibility)
                    }label: {
                        Label("通用设置", systemImage: "house.circle")
                    }
                    
                    .tag(0)
                    
                    
                    NavigationLink{
                        
                        vipCardSettingView(columnVisibility: $columnVisibility)
                            .navigationTitle("会员卡页面")
                    }label: {
                        Label("会员卡页面", systemImage: "pencil")
                    }
                    
                    .tag(4)
                    
                    
                    NavigationLink{
                        CategorySettingView(columnVisibility: $columnVisibility)
                            .navigationTitle("项目大类")
                    }label: {
                        Label("项目大类", systemImage: "pencil")
                    }
                    
                    .tag(5)
                    
                    
                    NavigationLink{
                        SubCategorySettingView(columnVisibility: $columnVisibility)
                            .navigationTitle("项目小类")
                    }label: {
                        Label("项目小类", systemImage: "pencil")
                    }
                    
                    .tag(6)
                    
                    NavigationLink{
                        ProjectSettingView(columnVisibility: $columnVisibility)
                            .navigationTitle("项目")
                    }label: {
                        Label("所有项目", systemImage: "pencil")
                    }
                    .tag(7)
                    
                    
                    
                }
                .listRowSpacing(20)
                .listStyle(.insetGrouped)
                
				.navigationTitle("设置")
				.gesture(
					DragGesture()
						.onEnded { value in
							if value.translation.width > 100 {
								manager.page = .home
							}
						}
				)
				.toolbar {
					ToolbarItem( placement: .topBarLeading){
						Button{
							uploadProgress = true
							manager.uploadItem(url: autoSetting.url){success in
								uploadProgress = false
								manager.toast(success ? "项目同步成功" : "项目同步失败", mode: success ? .success : .matrix)
							}
						}label:{
							
							if uploadProgress{
								ProgressView()
									.progressViewStyle(CircularProgressViewStyle())
							}else{
								Image(systemName: "icloud.and.arrow.up")
							}
							
					
							
						}.disabled(!manager.startsWithHttpOrHttps(autoSetting.url))
					}
				   
				}
			
			
			
		}content: {
			BasicSettingsView(columnVisibility: $columnVisibility)
			
		}detail:{
			
			AppSettings()
				.navigationTitle("App设置")
			
		}
		.onChange(of: selectedTab) { _, _ in
			self.columnVisibility = .doubleColumn
		}
		
		
	}
}


struct SettingsIphoneView: View {
	@EnvironmentObject var manager:peacock
    @State private var selectedTab:Int? = 0
    @State private var columnVisibility: NavigationSplitViewVisibility = .automatic
    @State private var showIconPicker:Bool = false
	@State private var uploadProgress:Bool  = false
	@Default(.autoSetting) var autoSetting
    var body: some View {
        NavigationStack{
            List(selection: $selectedTab) {
                
                Section{
                    NavigationLink{
                        AppSettings()
                            .navigationTitle("App设置")
                    }label: {
                        Label("App设置", systemImage: "house.circle")
                    }
                    
                    .tag(0)
                    
                    
                    
                    NavigationLink{
                        ExportDataView()
                            .navigationTitle("导出信息")
                    }label: {
                        Label("导出信息", systemImage: "square.and.arrow.up")
                    }
                    
                    .tag(1)
                    
                    NavigationLink{
                        ImportDataView()
                            .navigationTitle("导入信息")
                    }label: {
                        Label("导入信息", systemImage: "square.and.arrow.down")
                    }
                    
                    .tag(2)
                    
                   
                }
                
                Section{
                    Button{
                        self.showIconPicker.toggle()
                    }label:{
                       
                       Label("切换图标", systemImage: "photo.circle")
                    }
                    .sheet(isPresented: $showIconPicker) {
                        NavigationStack{
                            AppIconView()
                        }.presentationDetents([.medium])
                    }
                }
        
            
                Section {
                    NavigationLink{
                        
                        vipCardSettingView(columnVisibility: $columnVisibility)
                            .navigationTitle("会员卡页面")
                    }label: {
                        Label("会员卡页面", systemImage: "pencil")
                    }
                    
                    .tag(4)
                    
                    
                    NavigationLink{
                        CategorySettingView(columnVisibility: $columnVisibility)
                            .navigationTitle("项目大类")
                    }label: {
                        Label("项目大类", systemImage: "pencil")
                    }
                    
                    .tag(5)
                    
                    
                    NavigationLink{
                        SubCategorySettingView(columnVisibility: $columnVisibility)
                            .navigationTitle("项目小类")
                    }label: {
                        Label("项目小类", systemImage: "pencil")
                    }
                    
                    .tag(6)
                    
                    NavigationLink{
                        ProjectSettingView(columnVisibility: $columnVisibility)
                            .navigationTitle("项目")
                    }label: {
                        Label("所有项目", systemImage: "pencil")
                    }
                    .tag(7)
                    
                }
                
              
            }
			.toolbar {
				ToolbarItem( placement: .topBarLeading){
					Button{
						uploadProgress = true
						manager.uploadItem(url: autoSetting.url){success in
							uploadProgress = false
							manager.toast(success ? "项目同步成功" : "项目同步失败", mode: success ? .success : .matrix)
						}
					}label:{
						
						if uploadProgress{
							ProgressView()
								.progressViewStyle(CircularProgressViewStyle())
						}else{
							Image(systemName: "icloud.and.arrow.up")
						}
						
				
						
					}.disabled(!manager.startsWithHttpOrHttps(autoSetting.url))
				}
			   
			}
        }
    }
}




#Preview {
    SettingsView()
		.environmentObject(peacock.shared)
}
