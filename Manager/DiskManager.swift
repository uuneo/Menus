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
    
     func exportTotalData() -> TotalData{
         
         TotalData(Cards: Defaults[.Cards], Categorys: Defaults[.Categorys], Subcategorys: Defaults[.Subcategorys], Items: Defaults[.Items])
         
         
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
            Defaults[.Cards] = totalData.Cards
            Defaults[.Categorys] = totalData.Categorys
            Defaults[.Subcategorys] = totalData.Subcategorys
            Defaults[.Items] = totalData.Items
            return true
        }catch{
            return false
        }
    }
    
    func importData(url:URL) -> Bool{
        do{
            let data = try Data(contentsOf: url)
            let text = String(data: data, encoding: .utf8)!
            return importData(text: text)
        }catch{
            return false
        }
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
