//
//  DiskManageer.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/5.
//

import Foundation
import Defaults
import SwiftUI







//extension Defaults.Keys{
//
//
//    static let cards = Key<[MemberCardData]>("VipCards",default: MemberCardDataS)
//    static let categoryItems = Key<[CategoryData]>("CategoryItems",default: CategoryDataS)
//    static let subcategoryItems = Key<[SubCategoryData]>("SubcategoryItems",default: SubCategoryDataS)
//    static let items = Key<[ItemData]>("Items",default: ItemDataS)
//
//
//}
//


final class peacock:ObservableObject {
    
    
    static let shared = peacock()
    
    private init() { }
    
    @Published var selectedItem: CategoryData = CategoryData.example
    
    @Published var selectCard:MemberCardData = MemberCardData.nonmember
    
    @Published var showSettings:Bool = false
    
    @Published  var message: DemoMessage?
    
    private let session = URLSession(configuration: .default)
    
    
    func fetch<T:Codable>(url:String) async throws -> T?{
        guard let requestUrl = URL(string: url) else {return  nil}
        let data = try await session.data(for: URLRequest(url: requestUrl))
        let result = try JSONDecoder().decode(T.self, from: data)
        return result
    }
    
    func updateItem(url:String) async throws ->  Bool{
        
        if !startsWithHttpOrHttps(url){
            return false
        }
        
        if  let result:TotalData = try await self.fetch(url: url){
            return await self.importData(totaldata: result)
        }
        
        return false
    }
    
    func startsWithHttpOrHttps(_ urlString: String) -> Bool {
        let pattern = "^(http|https)://.*"
        let test = NSPredicate(format:"SELF MATCHES %@", pattern)
        return test.evaluate(with: urlString)
    }
    
}

extension peacock{
    func exportTotalData() -> TotalData{
        
        TotalData(Cards: Defaults[.Cards], Categorys: Defaults[.Categorys], Subcategorys: Defaults[.Subcategorys], Items: Defaults[.Items], homeCardTitle: Defaults[.homeCardTitle], homeCardSubTitle: Defaults[.homeCardSubTitle], homeItemsTitle: Defaults[.homeItemsTitle], homeItemsSubTitle: Defaults[.homeCardSubTitle], settingPassword: Defaults[.settingPassword], autoSetting: Defaults[.autoSetting])
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
    
    @MainActor func importData(text:String) -> Bool{
        let decoder = JSONDecoder()
        let data = text.data(using: .utf8)!
        do{
            let totalData = try decoder.decode(TotalData.self, from: data)
            
            return importData(totaldata: totalData)
        }catch{
            return false
        }
    }
    
    @MainActor func importData(totaldata:TotalData) -> Bool{
        let cards = totaldata.Cards
        let categorys = totaldata.Categorys
        let subcategorys = totaldata.Subcategorys
        let items = totaldata.Items
        let title =   totaldata.homeCardTitle
        let subTitle =  totaldata.homeCardSubTitle
        let itemTitle =  totaldata.homeItemsTitle
        let itemSubtitle =  totaldata.homeItemsSubTitle
        let setting =  totaldata.autoSetting
        let password =  totaldata.settingPassword
        
        
        if !cards.isEmpty{
            Defaults[.Cards] = cards
        }
        
        if !categorys.isEmpty{
            Defaults[.Categorys] = categorys
        }
        
        if !subcategorys.isEmpty{
            Defaults[.Subcategorys] = subcategorys
        }
        
        if !items.isEmpty{
            Defaults[.Items] = items
        }
        
        if let title = title{
            Defaults[.homeCardTitle] = title
        }
        
        if let subTitle = subTitle{
            Defaults[.homeCardSubTitle] = subTitle
        }
        
        if let itemTitle = itemTitle{
            Defaults[.homeItemsTitle] = itemTitle
        }
        
        if let itemSubtitle = itemSubtitle{
            Defaults[.homeItemsSubTitle] = itemSubtitle
        }
        
        if let setting = setting{
            Defaults[.autoSetting] = setting
        }
        
        if let password = password{
            Defaults[.settingPassword] = password
            
        }
        
        
        return true
    }
}

extension peacock{
    
    
    
    
    
    
    func removeCategoryItems(indexSet:IndexSet){
        
        for index in indexSet{
            let item = Defaults[.Categorys][index]
            Defaults[.Categorys].remove(at: index)
            Defaults[.Items] = Defaults[.Items].filter({$0.categoryId == item.id})
        }
    }
    
    func removeSubcategoryItems(indexSet:IndexSet){
        
        for index in indexSet{
            let item = Defaults[.Subcategorys][index]
            Defaults[.Subcategorys].remove(at: index)
            Defaults[.Items] = Defaults[.Items].filter{$0.subcategoryId != item.id}
        }
    }
    
    func removeItems(indexSet:IndexSet){
        
        for index in indexSet{
            Defaults[.Items].remove(at: index)
        }
    }
    
}
