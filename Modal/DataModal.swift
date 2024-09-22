//
//  DataModal.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/18.
//

import Foundation
import Defaults


extension Defaults.Keys{
    static let homeCardTitle = Key<String>("HomeCardTitle",default: "会员卡")
    static let homeCardSubTitle = Key<String>("HomeCardSubTitle",default: "Peacock-Cards")
    static let homeItemsTitle = Key<String>("HomeItemsTitle",default: "项目分类")
    static let homeItemsSubTitle = Key<String>("HomeItemsSubTitle",default: "Peacock-Items")
    static let settingPassword = Key<String>("SettingPassword",default: "")
    static let autoSetting = Key<AutoAsyncSetting>("AutoSetting",default: AutoAsyncSetting(url: "https://example.com/menus.json", enable: false))
    
    
    static let Cards = Key<[MemberCardData]>("MemberCards",default:MemberCardDataS)
    static let Categorys = Key<[CategoryData]>("Categorys",default:CategoryDataS)
    static let Subcategorys = Key<[SubCategoryData]>("Subcategorys",default: SubCategoryDataS)
    static let Items = Key<[ItemData]>("Items",default: ItemDataS)
}







struct MemberCardData: PeacockProtocol{
    var id: String = UUID().uuidString
    var title:String
    var subTitle:String
    var money:Int
    var name:String
    var discount:Double
    var discount2:Double
    var image:String
    var footer:String
    
    static let nonmember = MemberCardData(title: "非会员", subTitle: "Non-Member", money: 0, name: "原价", discount: 1, discount2: 1, image: "peacock4", footer: "啥也没有")
    
    static func space() -> MemberCardData {
        return MemberCardData(title: "新卡", subTitle: "", money: 0, name: "原价", discount: 1, discount2: 1, image: "peacock4", footer: "")
    }
}


struct CategoryData: PeacockProtocol {
    var id: String = UUID().uuidString
    var title:String
    var subTitle:String
    var image:String
    var color:String
    
    static func space() -> CategoryData {
        return CategoryData(title: "新项目", subTitle: "", image: "haircut", color: "background11")
    }
    
    static let example = CategoryData(title: "示例篇", subTitle: "Example Chapter", image: "haircut", color: "background11")
}


struct SubCategoryData: PeacockProtocol{
    
    var id: String = UUID().uuidString
    var categoryId:String
    var title:String
    var subTitle:String
    var footer:String
    
    static let example = SubCategoryData(categoryId:UUID().uuidString, title: "染发", subTitle: "Diamond", footer: "金钻会员专享")
    
    static func space() -> SubCategoryData {
        return SubCategoryData(categoryId: Defaults[.Categorys].first?.id ?? UUID().uuidString, title: "新项目", subTitle: "", footer: "")
    }
    
}

struct ItemData: PeacockProtocol{
    var id: String = UUID().uuidString
    var categoryId: String
    var subcategoryId: String
    var title: String
    var subTitle: String
    var header:String = ""
    var price1:PriceData
    var price2:PriceData
    var price3:PriceData
    var price4:PriceData
    
    static let example = ItemData(categoryId: UUID().uuidString, subcategoryId: UUID().uuidString, title: "示例项目", subTitle: "Example Item", price1: PriceData(prefix: "¥", money: 0, suffix: "元/次", discount: false), price2: PriceData(prefix: "¥", money: 0, suffix: "元/次", discount: false), price3: PriceData(prefix: "¥", money: 0, suffix: "元/6次", discount: false), price4: PriceData(prefix: "¥", money: 0, suffix: "元/12次", discount: false))
    
    static func space() -> ItemData {
        return ItemData(categoryId: Defaults[.Categorys].first?.id ?? UUID().uuidString, subcategoryId: Defaults[.Subcategorys].first?.id ?? UUID().uuidString, title: "新项目", subTitle: "NewItem", price1: PriceData(prefix: "¥", money: 0, suffix: "元/次", discount: false), price2: PriceData(prefix: "¥", money: 0, suffix: "元/次", discount: false), price3: PriceData(prefix: "¥", money: 0, suffix: "元/6次", discount: false), price4: PriceData(prefix: "¥", money: 0, suffix: "元/12次", discount: false))
    }
}

struct PriceData: PeacockProtocol{
    var id: String = UUID().uuidString
    var prefix:String
    var money:Int
    var suffix:String
    var discount:Bool = false
    
    static let example = PriceData(prefix: "¥", money: 0, suffix: "", discount: false)
    
    static func space() -> PriceData {
        return PriceData(prefix: "¥", money: 0, suffix: "", discount: false)
    }
}




struct AutoAsyncSetting: Codable,Defaults.Serializable{
	var url:String
    var enable:Bool
}


struct TotalData: Codable {
    var Cards:[MemberCardData]
    var Categorys:[CategoryData]
    var Subcategorys:[SubCategoryData]
    var Items:[ItemData]
    var homeCardTitle:String?
    var homeCardSubTitle:String?
    var homeItemsTitle:String?
    var homeItemsSubTitle:String?
    var settingPassword:String?
    var autoSetting:AutoAsyncSetting?
}

