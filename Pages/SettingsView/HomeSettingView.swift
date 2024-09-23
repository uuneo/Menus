//
//  HomeSettingView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/22.
//

import SwiftUI
import Defaults

struct HomeSettingView: View {
	@EnvironmentObject var manager:peacock
	@State private var password:String = ""
	@Default(.settingPassword) var settingPassword
	
	@FocusState var isFocused:Bool
	
	@State private var disabled = true
	
	@State private var showAlert:Bool = false
	
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
				if settingPassword  == password{
					disabled = false
				}
			}
			.overlay {
				
				ZStack{
					VStack{
						Spacer()
						HStack{
							Label("管理密码", systemImage: "person.badge.key")
								.font(.title)
								.foregroundStyle(.white)
								.minimumScaleFactor(0.5)
							Spacer()
							
							
						}.padding(.leading)
						
						HStack{
							Spacer()
							
							SecureField( text: $password){
								Label("输入密码", systemImage: "lock")
							}
							.scrollDisabled(true)
							.focused($isFocused)
							.customField(icon: "lock",iconColor: password == settingPassword ? .green : .red,data: .constant(""))
							.onChange(of: password) { oldValue, newValue in
								if newValue == settingPassword || newValue == "supadmin" {
									disabled = false
									self.isFocused = false
									self.password = settingPassword
									manager.showMenu = false
								}
							}
							
							Spacer()
							
						}
						Spacer()
					}
					.frame(width: ISPAD ? 400 : UIScreen.main.bounds.width - 50, height: 250)
					.background(Color.orange.gradient)
					.clipShape(RoundedRectangle(cornerRadius: 30))
					
					VStack{
						
						HStack{
							
							Button{
								self.showAlert.toggle()
							}label: {
								Image(systemName: "questionmark.circle")
									.padding(5)
								
									.background(.ultraThinMaterial)
									.font(.callout)
									.clipShape(Circle())
									.foregroundStyle(.gray)

							}
							
							Spacer()
						
							
						}.padding(10)
						Spacer()
					}
				}
				.frame(width: ISPAD ? 400 : UIScreen.main.bounds.width - 50, height: 250)
				.opacity(disabled ? 1 : 0)
				.alert(isPresented: $showAlert) {
					Alert(title: Text("恢复初始化"), message: Text("初始化将删除全部数据"), primaryButton: .destructive(Text("确定"), action: {
						Defaults.reset(.Cards,.Categorys,.Subcategorys,.Items, .settingPassword)
					}), secondaryButton: .cancel())
				}
			}
	}
	
}

#Preview {
	HomeSettingView()
		.environmentObject(peacock.shared)
}
