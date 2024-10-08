//
//  DataModal.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/18.
//

import Foundation
import Defaults
import CoreTransferable
import UniformTypeIdentifiers
import CryptoKit


extension Defaults.Keys{
	static let menusName = Key<String>("MenusName",default: String(localized: "美丽宫略"))
	static let menusSubName = Key<String>("MenusSubName",default: String(localized: "Peacock-Menus"))
	static let menusFooter = Key<String>("MenusFooter",default: String(localized: "一次相遇，终身美好"))
	static let menusImage = Key<String>("MenusImage",default: String(localized: "other"))
	static let homeCardTitle = Key<String>("HomeCardTitle",default: String(localized: "会员卡"))
	static let homeCardSubTitle = Key<String>("HomeCardSubTitle",default: String(localized: "Peacock-Cards"))
	static let homeItemsTitle = Key<String>("HomeItemsTitle",default: String(localized: "项目分类"))
	static let homeItemsSubTitle = Key<String>("HomeItemsSubTitle",default: String(localized: "Peacock-Items"))
	static let settingPassword = Key<String>("SettingPassword",default: "")
	static let autoSetting = Key<AutoAsyncSetting>("AutoSetting",default: AutoAsyncSetting(url: "https://example.com/menus.json", enable: false))
	
	
	static let Cards = Key<[MemberCardData]>("MemberCards",default:MemberCardDataS)
	static let Categorys = Key<[CategoryData]>("Categorys",default:CategoryDataS)
	static let Subcategorys = Key<[SubCategoryData]>("Subcategorys",default: SubCategoryDataS)
	static let Items = Key<[ItemData]>("Items",default: ItemDataS)
	
	
	
	static let firstStart = Key<Bool>("FirstStart",default: true)
	static let defaultHome = Key<Page>("defaultHome", default: Page.home)
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
	
    
	static let example = SubCategoryData(categoryId:UUID().uuidString, title: String(localized: "染发"), subTitle: String(localized: "Diamond"), footer: String(localized: "金钻会员专享"))
    
    static func space() -> SubCategoryData {
        return SubCategoryData(categoryId: Defaults[.Categorys].first?.id ?? UUID().uuidString, title: String(localized: "新项目"), subTitle: "", footer: "")
    }
	
	func copy() -> SubCategoryData {
		return SubCategoryData(id: UUID().uuidString, categoryId: categoryId, title: title, subTitle: subTitle, footer: footer)
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
    
    static let example = ItemData(categoryId: UUID().uuidString, subcategoryId: UUID().uuidString, title: String(localized: "示例项目"), subTitle: String(localized: "Example Item"), price1: PriceData(prefix: "¥", money: 0, suffix: String(localized: "元/次"), discount: false), price2: PriceData(prefix: "¥", money: 0, suffix: String(localized: "元/次"), discount: false), price3: PriceData(prefix: "¥", money: 0, suffix: String(localized: "元/6次"), discount: false), price4: PriceData(prefix: "¥", money: 0, suffix: String(localized: "元/12次"), discount: false))
    
    static func space() -> ItemData {
        return ItemData(categoryId: Defaults[.Categorys].first?.id ?? UUID().uuidString, subcategoryId: Defaults[.Subcategorys].first?.id ?? UUID().uuidString, title: String(localized: "新项目"), subTitle: String(localized: "NewItem"), price1: PriceData(prefix: "¥", money: 0, suffix: String(localized: "元/次"), discount: false), price2: PriceData(prefix: "¥", money: 0, suffix: String(localized: "元/次"), discount: false), price3: PriceData(prefix: "¥", money: 0, suffix: String(localized: "元/6次"), discount: false), price4: PriceData(prefix: "¥", money: 0, suffix: String(localized: "元/12次"), discount: false))
    }
	
	func copy() -> ItemData {
		return ItemData( id: UUID().uuidString, categoryId: categoryId, subcategoryId: subcategoryId, title: title, subTitle: subTitle, header: header, price1: price1, price2: price2, price3: price3, price4: price4)
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
	var menusName:String?
	var menusSubName:String?
	var menusFooter:String?
	var menusImage:String?
    var homeCardTitle:String?
    var homeCardSubTitle:String?
    var homeItemsTitle:String?
    var homeItemsSubTitle:String?
    var settingPassword:String?
    var autoSetting:AutoAsyncSetting?
	

	
	
}


extension TotalData:Transferable{
	static var transferRepresentation: some TransferRepresentation{
		
		
		DataRepresentation(exportedContentType: .trnExportType){
			let data = try JSONEncoder().encode($0)
			guard let encrypteData = try AES.GCM.seal(data, using: .trnKey).combined else{
				throw EncryptionError.failed
			}
			return encrypteData
		}
		.suggestedFileName("PeacockMenus-\(Date().yyyyMMddhhmmss())")
		
			
	}
	enum EncryptionError:Error{
		case failed
	}
	

}


extension UTType{
	static var trnExportType = UTType(exportedAs: "com.twown.PeacockMenus.menus")
}

extension SymmetricKey{
	static var trnKey :SymmetricKey{
		let key = "iJUSTINE".data(using: .utf8 )!
		let sha256 = SHA256.hash(data: key)
		return .init(data: sha256)
	}
}


extension Date{
	func yyyyMMddhhmmss() -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"  // 自定义格式
		return formatter.string(from: self)  // 返回格式化的日期字符串
	}
}
