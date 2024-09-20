//
//  PeacockMenusApp.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/2.
//

import SwiftUI
import Defaults
import SwiftMessages


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
                        Task{
                            if autoSetting.enable,
                               let success  =  try? await manager.updateItem(url: autoSetting.url){
                               
                                DispatchQueue.main.async {
                                    manager.message = .init(title: "提示", body: success ? "更新成功"  : "更新失败")
                                }
                            }else{
                                DispatchQueue.main.async {
                                    manager.message = .init(title: "提示", body: "自动更新未启用或者地址错误")
                                }
                            }
                        }
                    }
                   
                }
                .swiftMessage(message: $manager.message)
            
        }
    }
    
    
}

