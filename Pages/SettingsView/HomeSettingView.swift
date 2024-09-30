//
//  HomeSettingView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/22.
//

import SwiftUI
import Defaults
import TipKit

struct HomeSettingView: View {
	@EnvironmentObject var manager:peacock
	@Default(.settingPassword) var settingPassword
	
	@FocusState var isFocused:Bool
	
	@State private var disabled = true
	
	@State private var showAlert:Bool = false
	
	
	@State private var showPopup: Bool = false
	@State private var showAlert2: Bool = false
	@State private var isWrongPassword: Bool = false
	@State private var isTryingAgain: Bool = false
	
	
	var body: some View {
		ZStack{
			if ISPAD{
				SettingsView()
			}else{
				SettingsIphoneView()
			}
		}
		
		
		.disabled(disabled)
		.blur(radius: disabled ? 10 : 0)
		.onAppear{
			withAnimation {
				disabled = settingPassword  != ""
				self.showPopup = true
			}
			
		}
		
		.alert(isPresented: $showAlert) {
			Alert(title: Text("恢复初始化"), message: Text("初始化将删除全部数据"), primaryButton: .destructive(Text("确定"), action: {
				Defaults.reset(.Cards,.Categorys,.Subcategorys,.Items, .settingPassword)
			}), secondaryButton: .cancel())
		}
		
		.popView(isPresented: $showPopup) {
			withAnimation {
				showAlert2 = isWrongPassword
				isWrongPassword = false
			}
			
		} content: {
			CustomAlertWithTextField(show: $showPopup) { password in
				withAnimation {
					if password == settingPassword {
						self.disabled = false
					} else if password == "canceAndCloselView" {
						manager.page = .home
					}else{
						isWrongPassword = true
					}
				}
				
			}
		}
		.popView(isPresented: $showAlert2) {
			withAnimation {
				showPopup = isTryingAgain
				isTryingAgain = false
			}
			
		} content: {
			CustomAlert(show: $showAlert2) { success in
				withAnimation {
					if success{
						isTryingAgain = true
					}else{
						manager.page = .home
					}
					
				}
				
				
			}
		}
		
		
		
		
	}
	
}

#Preview {
	HomeSettingView()
		.environmentObject(peacock.shared)
}
