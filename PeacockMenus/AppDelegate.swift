//
//  AppDelegate.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/16.
//

import Foundation
import UIKit


class AppDelegate: UIResponder,  UIApplicationDelegate{
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
           // 处理接收到的 URL
           print("Received URL: \(url)")
           // 读取文件或进行其他操作
           return true
       }
    
}
