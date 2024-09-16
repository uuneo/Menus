//
//  ItemData.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/13.
//

import Foundation
import SwiftUI
import Defaults


struct categoryData: PeacockProtocol {
    
    var id:String = UUID().uuidString
    var title: String
    var subTitle:String
    var image: String
    var color: String
    
    static func space()-> categoryData {
        return categoryData(title: "新项目", subTitle: "", image: "haircut", color: "background11")
    }
 
}




struct subcategoryData:PeacockProtocol{
    var id:String = UUID().uuidString
    var categoryId:String
    var title:String
    var subTitle:String
    var footer:String
    
    static let example = subcategoryData(categoryId: UUID().uuidString, title: "染发", subTitle: "Diamond", footer: "金钻会员专享")
    
    static func space()->subcategoryData{
        return subcategoryData(categoryId:  Defaults[.categoryItems].first?.id  ?? UUID().uuidString, title: "新项目", subTitle: "", footer: "")
    }
    
    
}




struct itemData: PeacockProtocol {
    var id:String = UUID().uuidString
    var subcategoryId:String = UUID().uuidString
    var title:String
    var subTitle:String
    var price1:PriceData
    var price2:PriceData
    var price3:PriceData
    var price4:PriceData
    
    static let example = itemData(subcategoryId: UUID().uuidString, title: "染发", subTitle: "Hair Dye", price1: PriceData(prefix: "单次 ¥", money: 100, suffix: "元"), price2: PriceData(prefix: "会员 ¥", money: 80, suffix: "元"), price3: PriceData(prefix: "2次 ¥", money: 180, suffix: "元"), price4: PriceData(prefix: "3次 ¥", money: 250, suffix: "元"))
    

    static func space()->itemData{
        return itemData(subcategoryId: Defaults[.subcategoryItems].first?.id ?? UUID().uuidString, title: "新项目", subTitle: "", price1: PriceData(prefix: "单次 ¥", money: 0, suffix: "元"), price2: PriceData(prefix: "会员 ¥", money: 0, suffix: "元"), price3: PriceData(prefix: "6次 ¥", money: 0, suffix: "元"), price4: PriceData(prefix: "12次 ¥", money: 0, suffix: "元"))
    }
    
}


struct PriceData:PeacockProtocol{
    var id: String = UUID().uuidString
    var prefix:String
    var money:Int
    var suffix:String
    var discount:Bool = false
    static let example = PriceData(prefix: "单次 ¥", money: 100, suffix: "元")
}




extension categoryData{
    
    static let example = categoryData(title: "示例篇",
                                            subTitle: "Hair Cut Chapter",
                                            image: "haircut",
                                            color: "background11")
    static  let datas = [
        categoryData(title: "基础篇",
                 subTitle: "Hair Cut Chapter",
                 image: "haircut",
                 color: "background11"),
        categoryData(title: "烫发篇",
                 subTitle: "Perming Chapter",
                 image: "hairperm",
                 color: "background3"),
        categoryData(title: "染发篇",
                 subTitle: "Hair Dyeing Chapter",
                 image: "haircolors",
                 color: "background4"),
        categoryData(title: "护理篇",
                 subTitle: "Hair Care Chapter",
                 image: "haircare",
                 color: "background7"),
        categoryData(title: "头皮健康",
                 subTitle: "Scalp Care Chapter",
                 image: "headcare",
                 color: "background8"),
        categoryData(title: "美容篇",
                 subTitle: "Beauty Chapter",
                 image: "beauty",
                 color: "background9")
    ]
}
