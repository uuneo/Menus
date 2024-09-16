//
//  TotalData.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/15.
//

import Foundation



struct TotalData:Codable{
    var vipCards:[VipCardData]
    var categoryItems:[categoryData]
    var subcategoryItems:[subcategoryData]
    var items:[itemData]
}
