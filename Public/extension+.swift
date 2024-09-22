//
//  shape+.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/13.
//

import Foundation
import SwiftUI




extension Color{
    init(from comm: String) {
        // 判断是否是十六进制颜色代码
        if comm.hasPrefix("#") || comm.range(of: "^[0-9A-Fa-f]{3,8}$", options: .regularExpression) != nil {
            self = Color(hex: comm)
        } else {
            // 默认作为资源名称初始化
            self = Color(comm)
        }
    }
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0) // 处理无效输入，默认白色
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
