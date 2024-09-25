//
//  PeacockMenusApp.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/2.
//

import SwiftUI
import Defaults
import TipKit

@main
struct PeacockMenusApp: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	@Default(.autoSetting) var autoSetting
	@Default(.firstStart) var firstStart
	@Environment(\.scenePhase) var scenePhase
	@StateObject var manager = peacock.shared
	
	var body: some Scene {
		WindowGroup {
			ContentView()
				.onChange(of: scenePhase) { _, newvalue in
					
					switch newvalue{
					case .active:
						if !firstStart{
							manager.updateItem(url: autoSetting.url)
						}
					case .background:
						if firstStart && !manager.resetType{
							firstStart = false
							SettingTipView.startTipHasDisplayed = false
						}
					default:
						break
					}
					
					
				}
				.environmentObject(manager)
				.task {
					// 在每次视图刷新时将 TipKit 数据库重置为初始状态
//					try? Tips.resetDatastore()
					
					DispatchQueue.main.async{
						manager.resetType = false
					}
					
					try? Tips.configure([
						.displayFrequency(.immediate),
						.datastoreLocation(.applicationDefault)
					])
				}
			
			
		}
	}
	
	
}
