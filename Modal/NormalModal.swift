//
//  NormalModal.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/6.
//

import Foundation





final class NormalItemData: PeacockProtocol{
    var id: String = UUID().uuidString
    var page:String
    var itemName:String
    var itemType:String
    var footer:String
    var header:String
    var prices:[PriceData]
    var profile:String = ""

    
    init(page: String, itemName: String, itemType: String, footer: String = "", header: String = "", prices: [PriceData],profile:String = "") {
        self.page = page
        self.itemName = itemName
        self.itemType = itemType
        self.footer = footer
        self.header = header
        self.prices = prices
        self.profile = profile
    }
    
    static let def = NormalItemData(page: UUID().uuidString, itemName: "卡诗奢宠黑钻", itemType: "护理" , prices: [PriceData.def])
    

    
   
}
