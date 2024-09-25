//
//  SettingsView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/8.
//

import SwiftUI
import Defaults
import TipKit



enum ActiveAlert {
	case uploadData, showTip
}


struct SettingsView: View {
	@EnvironmentObject var manager:peacock
	@Default(.settingPassword) var settingPassword
	@Default(.autoSetting) var autoSetting
	@Default(.firstStart) var firstStart
	
	@State private var changeTitle:Bool = false
	
	@State private var selectedTab:Int? = 0
	
	@State private var columnVisibility: NavigationSplitViewVisibility = .all
	
	@State private var uploadProgress:Bool  = false
	
	@State private var showTips:Bool = true
	
	@State private var showAlert:Bool = false
	
	@State private var activeAlert:ActiveAlert = .uploadData
	
	let uploadTip = UploadTipView()
	
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
			.alert(isPresented: $showAlert) {
				
				switch activeAlert {
				case .uploadData:
					Alert(title: Text("上传数据"), message: Text("本地数据将覆盖服务器数据"), primaryButton: .destructive(Text("确定"), action: {
						uploadProgress = true
						manager.uploadItem(url: autoSetting.url){success in
							uploadProgress = false
							manager.toast(success ? String(localized: "项目同步成功") : String(localized: "项目同步失败"), mode: success ? .success : .matrix)
						}
					}), secondaryButton: .cancel())
				case .showTip:
					Alert(title: Text("显示提示"), message: Text("重新展示提示信息"), primaryButton: .destructive(Text("确定"), action: {
						try? Tips.resetDatastore()
						firstStart = true
						manager.resetType = true
					}), secondaryButton: .cancel())
				}
				
				
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
						if UploadTipView.startTipHasDisplayed{
							activeAlert = .uploadData
							showAlert.toggle()
						}
						UploadTipView.startTipHasDisplayed = true
						
					}label:{
						if uploadProgress{
							ProgressView()
								.progressViewStyle(CircularProgressViewStyle())
						}else{
							Image(systemName: "icloud.and.arrow.up")
								.popoverTip(uploadTip){action in
									
									debugPrint(action)
									
								}
							
						}
						
					}
				}
				ToolbarItem{
					Button{
						showAlert.toggle()
						activeAlert = .showTip
					}label:{
						Image(systemName: "questionmark.circle")
					}
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
	
	@State private var showAlert:Bool = false
	
	let uploadIphoneTip = UploadTipView()
	
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
			.alert(isPresented: $showAlert) {
				Alert(title: Text("上传数据"), message: Text("本地数据将覆盖服务器数据"), primaryButton: .destructive(Text("确定"), action: {
					uploadProgress = true
					manager.uploadItem(url: autoSetting.url){success in
						uploadProgress = false
						manager.toast(success ? String(localized: "项目同步成功") : String(localized: "项目同步失败"), mode: success ? .success : .matrix)
					}
				}), secondaryButton: .cancel())
			}
			.toolbar {
				ToolbarItem( placement: .topBarLeading){
					Button{
						self.showAlert.toggle()
					}label:{
						
						Group{
							if uploadProgress{
								ProgressView()
									.progressViewStyle(CircularProgressViewStyle())
							}else{
								Image(systemName: "icloud.and.arrow.up")
									.popoverTip(uploadIphoneTip)
							}
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
