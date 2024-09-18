//
//  ItemData.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/13.
//

import Foundation
import SwiftUI
import Defaults

//
//struct MemberCardData: PeacockProtocol {
//    var id:String = UUID().uuidString
//    var title: String
//    var subTitle:String
//    var money:Int
//    var name:String
//    var discount:Double
//    var discount2:Double
//    var image: String
//    var footer:String
//    
//    static let nonmember = MemberCardData(title: "非会员", subTitle: "Non-Member", money: 0, name: "原价", discount: 1, discount2: 1, image: "peacock4",footer: "啥也没有")
//    
//    static func space()-> MemberCardData {
//        return MemberCardData(title: "新卡", subTitle: "", money: 0, name: "原价", discount: 1, discount2: 1, image: "peacock4",footer: "")
//    }
//    
//    
//}
//
//
//struct CategoryData: PeacockProtocol {
//    
//    var id:String = UUID().uuidString
//    var title: String
//    var subTitle:String
//    var image: String
//    var color: String
//    
//    static func space()-> CategoryData {
//        return CategoryData(title: "新项目", subTitle: "", image: "haircut", color: "background11")
//    }
//    
//    static let example = CategoryData(title: "示例篇", subTitle: "Example Chapter",image: "haircut", color: "background11")
//    
//}
//
//
//
//
//struct SubCategoryData:PeacockProtocol{
//    var id:String = UUID().uuidString
//    var categoryId:String
//    var title:String
//    var subTitle:String
//    var footer:String
//    
//    static let example = SubCategoryData( categoryId: UUID().uuidString, title: "染发", subTitle: "Diamond", footer: "金钻会员专享")
//    
//    
//    static func space()->SubCategoryData{
//        return SubCategoryData(categoryId: Defaults[.categoryItems].first?.id ?? UUID().uuidString, title: "新项目", subTitle: "NewItem", footer: "")
//    }
//    
//    
//}
//
//
//
//
//
//
//struct ItemData: PeacockProtocol {
//    var id:String = UUID().uuidString
//   
//    var subcategoryId:String
//    var title:String
//    var subTitle:String
//    var price1:PriceData
//    var price2:PriceData
//    var price3:PriceData
//    var price4:PriceData
//    
//    static let example = ItemData(subcategoryId: UUID().uuidString, title: "染发", subTitle: "Hair Dye", price1: PriceData(prefix: "单次 ¥", money: 100, suffix: "元"), price2: PriceData(prefix: "会员 ¥", money: 80, suffix: "元"), price3: PriceData(prefix: "2次 ¥", money: 180, suffix: "元"), price4: PriceData(prefix: "3次 ¥", money: 250, suffix: "元"))
//    
//    
//    static func space()->ItemData{
//
//        
//        return ItemData(subcategoryId: Defaults[.subcategoryItems].first?.id ?? UUID().uuidString, title: "染发", subTitle: "Hair Dye", price1: PriceData(prefix: "单次 ¥", money: 100, suffix: "元"), price2: PriceData(prefix: "会员 ¥", money: 80, suffix: "元"), price3: PriceData(prefix: "2次 ¥", money: 180, suffix: "元"), price4: PriceData(prefix: "3次 ¥", money: 250, suffix: "元"))
//    }
//    
//}
//
//
//struct PriceData:PeacockProtocol{
//    var id: String = UUID().uuidString
//    var prefix:String
//    var money:Int
//    var suffix:String
//    var discount:Bool = false
//    static let example = PriceData(prefix: "¥", money: 100, suffix: "元/次")
//    static func space()->PriceData{
//        return PriceData(prefix: "¥", money: 0, suffix: "元/次")
//    }
//}
//
//
//
//
//
//struct TotalData:Codable{
//    var vipCards:[MemberCardData]
//    var categoryItems:[CategoryData]
//    var subcategoryItems:[SubCategoryData]
//    var items:[ItemData]
//}
