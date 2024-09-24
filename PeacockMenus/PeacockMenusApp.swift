//
//  PeacockMenusApp.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/2.
//

import SwiftUI
import Defaults

@main
struct PeacockMenusApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Default(.autoSetting) var autoSetting
    @Environment(\.scenePhase) var scenePhase
	@StateObject var manager = peacock.shared
	
	var body: some Scene {
		WindowGroup {
			ContentView()
				.onChange(of: scenePhase) { _, newvalue in
					
					if newvalue == .active{
						manager.updateItem(url: autoSetting.url)
					}
				}
				.environmentObject(manager)
				
			
			
		}
	}
	
	
}
