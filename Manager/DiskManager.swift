//
//  DiskManageer.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/5.
//

import Foundation
import Defaults
import SwiftUI







extension Defaults.Keys{
    static let homeCardTitle = Key<String>("HomeCardTitle",default: "会员卡")
    static let homeCardSubTitle = Key<String>("HomeCardSubTitle",default: "Peacock-Cards")
    static let homeItemsTitle = Key<String>("HomeItemsTitle",default: "项目分类")
    static let homeItemsSubTitle = Key<String>("HomeItemsSubTitle",default: "Peacock-Items")
    static let settingPassword = Key<String>("SettingPassword",default: "admin")

    
    static let cards = Key<[VipCardData]>("VipCards",default: VIPCARDDATAS)
    static let categoryItems = Key<[categoryData]>("CategoryItems",default: CATEGORYDATAS)
    static let subcategoryItems = Key<[subcategoryData]>("SubcategoryItems",default: SUBCATEGORYdATAS)
    static let items = Key<[itemData]>("Items",default: ITEMDATAS)
    

}



final class peacock:ObservableObject {
  
    
    static let shared = peacock()
    
    private init() { }
    
    @Published var selectedItem: categoryData = categoryData.example
    
    @Published var selectCard:VipCardData = VipCardData.nonmember
    
    @Published var showSettings:Bool = false
    
     func exportTotalData() -> TotalData{
        TotalData(vipCards: Defaults[.cards], categoryItems: Defaults[.categoryItems], subcategoryItems: Defaults[.subcategoryItems], items: Defaults[.items])
    }
    
    func exportData() -> String{
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(exportTotalData())
        return String(data: data, encoding: .utf8)!
    }
    
    func saveJSONToTempFile<T: Encodable>(object: T, fileName: String) -> URL? {
        // 获取临时目录
        let tempDirectory = FileManager.default.temporaryDirectory
        
        // 创建临时文件的 URL
        let tempFileURL = tempDirectory.appendingPathComponent(fileName).appendingPathExtension("json")
        
        do {
            // 创建 JSON 编码器
            let encoder = JSONEncoder()
            // 将对象编码为 JSON 数据
            let jsonData = try encoder.encode(object)
            
            // 写入 JSON 数据到临时文件
            try jsonData.write(to: tempFileURL, options: .atomic)
            
            // 返回文件 URL
            return tempFileURL
        } catch {
            // 捕获并打印错误
            print("Error saving JSON file: \(error.localizedDescription)")
            return nil
        }
    }
    
    func importData(text:String) -> Bool{
        let decoder = JSONDecoder()
        let data = text.data(using: .utf8)!
        do{
            let totalData = try decoder.decode(TotalData.self, from: data)
            Defaults[.cards] = totalData.vipCards
            Defaults[.categoryItems] = totalData.categoryItems
            Defaults[.subcategoryItems] = totalData.subcategoryItems
            Defaults[.items] = totalData.items
            return true
        }catch{
            return false
        }
    }
  
}

extension peacock{
    func removeCategoryItems(indexSet:IndexSet){
        
        for index in indexSet{
            let item = Defaults[.categoryItems][index]
            Defaults[.categoryItems].remove(at: index)
            Defaults[.subcategoryItems] = Defaults[.subcategoryItems].filter{$0.categoryId != item.id}
            Defaults[.items] = Defaults[.items].filter{$0.subcategoryId != item.id}
        }
    }
    
    func removeSubcategoryItems(indexSet:IndexSet){
        
        for index in indexSet{
            let item = Defaults[.subcategoryItems][index]
            Defaults[.subcategoryItems].remove(at: index)
            Defaults[.items] = Defaults[.items].filter{$0.subcategoryId != item.id}
        }
    }
    
    func removeItems(indexSet:IndexSet){
        
        for index in indexSet{
            Defaults[.items].remove(at: index)
        }
    }
    
}
