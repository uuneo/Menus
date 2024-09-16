//
//  VipCardData.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/13.
//

import Foundation
import SwiftUI



struct VipCardData: PeacockProtocol {
    var id:String = UUID().uuidString
    var title: String
    var subTitle:String
    var money:Int
    var name:String
    var discount:Double
    var discount2:Double
    var image: String
    var footer:String
    
}

extension VipCardData{

    
    static let example = VipCardData(title: "钻卡", subTitle: "Diamond Card", money: 88888, name: "3折", discount: 0.3, discount2: 0.7, image: "peacock1",footer: "1. 课程折扣7折")
    
    static let space = VipCardData(title: "新卡片", subTitle: "", money: 0, name: "", discount: 0.3, discount2: 0.7, image: "peacock1",footer: "")
    
    
    static let datas = [
        VipCardData(title: "钻卡", subTitle: "Diamond Card", money: 60000, name: "3折", discount: 0.3, discount2: 0.7, image: "peacock1",footer: "1. 课程折扣7折\n2. 卡诗洗发水"),
        VipCardData(title: "金卡", subTitle: "Gold Card", money: 20000, name: "3折", discount: 0.3, discount2: 0.8, image: "peacock2",footer: "1. 课程折扣8折"),
        VipCardData(title: "银卡", subTitle: "Silver Card", money: 10000, name: "5折", discount: 0.5, discount2: 0.8, image: "peacock3",footer: "1. 课程折扣8折"),
        VipCardData(title: "普卡", subTitle: "Basic Card", money: 5000, name: "5折", discount: 0.5, discount2: 1, image: "peacock6",footer: " 会员优先服务"),
        VipCardData(title: "普卡", subTitle: "Basic Card", money: 2000, name: "7折", discount: 0.7, discount2: 1, image: "peacock6",footer: " 会员优先服务")
        
    ]
    
    static let nonmember = VipCardData(title: "非会员", subTitle: "Non-Member", money: 0, name: "原价", discount: 1, discount2: 1, image: "peacock4",footer: "啥也没有")
    
}
