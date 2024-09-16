//
//  Example.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/16.
//

import Foundation



let VIPCARDDATAS = [
    VipCardData( id: "A9428706-94C6-4944-BF1A-76036895818A",title: "钻卡", subTitle: "Diamond Card", money: 20000, name: "3折", discount: 0.3, discount2: 0.7, image: "peacock1",footer: "1. 课程折扣7折\n2. 卡诗洗发水"),
    VipCardData(id: "B9428706-94C6-4944-BF1A-76036895818B",title: "金卡", subTitle: "Gold Card", money: 15000, name: "6折", discount: 0.6, discount2: 0.8, image: "peacock2",footer: "1. 课程折扣8折"),
    VipCardData(id: "C9428706-94C6-4944-BF1A-76036895818C",title: "银卡", subTitle: "Silver Card", money: 10000, name: "7折", discount: 0.7, discount2: 0.9, image: "peacock3",footer: "1. 课程折扣8折"),
    VipCardData(id: "D9428706-94C6-4944-BF1A-76036895818D",title: "普卡", subTitle: "Basic Card", money: 5000, name: "8折", discount: 0.8, discount2: 1, image: "peacock6",footer: " 会员优先服务"),
    VipCardData(id: "E9428706-94C6-4944-BF1A-76036895818E",title: "普卡", subTitle: "Basic Card", money: 2000, name: "8折", discount: 0.9, discount2: 1, image: "peacock6",footer: " 会员优先服务")
]


let CATEGORYDATAS = [
    categoryData(id: "F9428706-94C6-4944-BF1A-76036895818F",title: "基础篇", subTitle: "Hair Cut Chapter", image: "haircut", color: "background11"),
    categoryData(id: "G9428706-94C6-4944-BF1A-76036895818G",title: "烫发篇", subTitle: "Perming Chapter", image: "hairperm", color: "background3"),
    categoryData(id: "H9428706-94C6-4944-BF1A-76036895818H",title: "染发篇", subTitle: "Hair Dyeing Chapter", image: "haircolors", color: "background4"),
    categoryData(id: "J9428706-94C6-4944-BF1A-76036895818J",title: "护理篇", subTitle: "Hair Care Chapter", image: "haircare", color: "background7"),
    categoryData(id: "K9428706-94C6-4944-BF1A-76036895818K",title: "头皮健康", subTitle: "Scalp Care Chapter", image: "headcare", color: "background8"),
    categoryData(id: "L9428706-94C6-4944-BF1A-76036895818L",title: "美容篇", subTitle: "Beauty Chapter", image: "beauty", color: "background9")
]

let SUBCATEGORYdATAS = [
    subcategoryData(id: "F9428706-94C6-4944-BF1A-76036800001F", categoryId: "F9428706-94C6-4944-BF1A-76036895818F", title: "总监", subTitle: "DIRECTORS", footer: ""),
    subcategoryData(id: "F9428706-94C6-4944-BF1A-76036800011F", categoryId: "F9428706-94C6-4944-BF1A-76036895818F", title: "首席", subTitle: "DIRECTORS", footer: ""),
    
    subcategoryData(id: "F9428706-94C6-4944-BF1A-76036800002F", categoryId: "G9428706-94C6-4944-BF1A-76036895818G", title: "菲灵", subTitle: "Perming", footer: ""),
    subcategoryData(id: "F9428706-94C6-4944-BF1A-76036800022F", categoryId: "G9428706-94C6-4944-BF1A-76036895818G", title: "威娜", subTitle: "Perming", footer: ""),
    
    
    subcategoryData(id: "F9428706-94C6-4944-BF1A-76036800003F", categoryId: "H9428706-94C6-4944-BF1A-76036895818H", title: "菲灵", subTitle: "Hair Dyeing", footer: ""),
    subcategoryData(id: "F9428706-94C6-4944-BF1A-76036800033F", categoryId: "H9428706-94C6-4944-BF1A-76036895818H", title: "威娜", subTitle: "Hair Dyeing", footer: ""),
    
    
    
    
    subcategoryData(id: "F9428706-94C6-4944-BF1A-76036800004F", categoryId: "J9428706-94C6-4944-BF1A-76036895818J", title: "菲灵", subTitle: "Hair Care", footer: ""),
    subcategoryData(id: "F9428706-94C6-4944-BF1A-76036800044F", categoryId: "J9428706-94C6-4944-BF1A-76036895818J", title: "威娜", subTitle: "Hair Care", footer: ""),
    
    
    subcategoryData(id: "F9428706-94C6-4944-BF1A-76036800005F", categoryId: "K9428706-94C6-4944-BF1A-76036895818K", title: "菲灵", subTitle: "Scalp Care", footer: ""),
    subcategoryData(id: "F9428706-94C6-4944-BF1A-76036800055F", categoryId: "K9428706-94C6-4944-BF1A-76036895818K", title: "卡彼", subTitle: "Scalp Care", footer: ""),
    
    
    subcategoryData(id: "F9428706-94C6-4944-BF1A-76036800006F", categoryId: "L9428706-94C6-4944-BF1A-76036895818L", title: "身体", subTitle: "Beauty", footer: ""),
    subcategoryData(id: "F9428706-94C6-4944-BF1A-76036800066F", categoryId: "L9428706-94C6-4944-BF1A-76036895818L", title: "面部", subTitle: "Beauty", footer: ""),

]

let ITEMDATAS = [
    
    itemData(id: "F9428706-94C6-4944-BF1A-76036880001F", subcategoryId: "F9428706-94C6-4944-BF1A-76036800001F", title: "剪发", subTitle: "Hair Cut", price1: PriceData(prefix: "¥", money: 100, suffix: "元/次",discount: true), price2: PriceData(prefix: "会员¥", money: 80, suffix: "元/次",discount: true), price3: PriceData(prefix: "¥", money: 180, suffix: "元/6次",discount: true), price4: PriceData(prefix: "¥", money: 250, suffix: "元/12次",discount: true)),
    
    itemData(id: "F9428706-94C6-4944-BF1A-76036880011F", subcategoryId: "F9428706-94C6-4944-BF1A-76036800001F", title: "造型", subTitle: "Hair Cut", price1: PriceData(prefix: "¥", money: 100, suffix: "元/次",discount: true), price2: PriceData(prefix: "会员¥", money: 80, suffix: "元/次",discount: true), price3: PriceData(prefix: "¥", money: 180, suffix: "元/6次",discount: true), price4: PriceData(prefix: "¥", money: 250, suffix: "元/12次", discount: true)),
    
    itemData(id: "F9428706-94C6-4944-BF1A-76036880001F", subcategoryId: "F9428706-94C6-4944-BF1A-76036800011F", title: "剪发", subTitle: "Hair Cut", price1: PriceData(prefix: "¥", money: 100, suffix: "元/次",discount: true), price2: PriceData(prefix: "会员¥", money: 80, suffix: "元/次",discount: true), price3: PriceData(prefix: "¥", money: 180, suffix: "元/6次",discount: true), price4: PriceData(prefix: "¥", money: 250, suffix: "元/12次",discount: true)),
    
    itemData(id: "F9428706-94C6-4944-BF1A-76036880111F", subcategoryId: "F9428706-94C6-4944-BF1A-76036800011F", title: "造型", subTitle: "Hair Cut", price1: PriceData(prefix: "¥", money: 100, suffix: "元/次",discount: true), price2: PriceData(prefix: "会员¥", money: 80, suffix: "元/次",discount: true), price3: PriceData(prefix: "¥", money: 180, suffix: "元/6次",discount: true), price4: PriceData(prefix: "¥", money: 250, suffix: "元/12次",discount: true)),
    
    itemData(id: "F9428706-94C6-4944-BF1A-76036880002F", subcategoryId: "F9428706-94C6-4944-BF1A-76036800002F", title: "烫发", subTitle: "Hair Cut", price1: PriceData(prefix: "¥", money: 100, suffix: "元/次",discount: true), price2: PriceData(prefix: "会员¥", money: 80, suffix: "元/次",discount: true), price3: PriceData(prefix: "¥", money: 180, suffix: "元/6次",discount: true), price4: PriceData(prefix: "¥", money: 250, suffix: "元/12次",discount: true)),
    itemData(id: "F9428706-94C6-4944-BF1A-76036880022F", subcategoryId: "F9428706-94C6-4944-BF1A-76036800022F", title: "烫发", subTitle: "Hair Cut", price1: PriceData(prefix: "¥", money: 100, suffix: "元/次",discount: true), price2: PriceData(prefix: "会员¥", money: 80, suffix: "元/次",discount: true), price3: PriceData(prefix: "¥", money: 180, suffix: "元/6次",discount: true), price4: PriceData(prefix: "¥", money: 250, suffix: "元/12次",discount: true)),
    
    itemData(id: "F9428706-94C6-4944-BF1A-76036880003F", subcategoryId: "F9428706-94C6-4944-BF1A-76036800003F", title: "染发", subTitle: "Hair Cut", price1: PriceData(prefix: "¥", money: 100, suffix: "元/次",discount: true), price2: PriceData(prefix: "会员¥", money: 80, suffix: "元/次",discount: true), price3: PriceData(prefix: "¥", money: 180, suffix: "元/6次",discount: true), price4: PriceData(prefix: "¥", money: 250, suffix: "元/12次",discount: true)),
    itemData(id: "F9428706-94C6-4944-BF1A-76036880033F", subcategoryId: "F9428706-94C6-4944-BF1A-76036800033F", title: "染发", subTitle: "Hair Cut", price1: PriceData(prefix: "¥", money: 100, suffix: "元/次",discount: true), price2: PriceData(prefix: "会员¥", money: 80, suffix: "元/次",discount: true), price3: PriceData(prefix: "¥", money: 180, suffix: "元/6次",discount: true), price4: PriceData(prefix: "¥", money: 250, suffix: "元/12次",discount: true)),
    itemData(id: "F9428706-94C6-4944-BF1A-76036880004F", subcategoryId: "F9428706-94C6-4944-BF1A-76036800004F", title: "护理", subTitle: "Hair Cut", price1: PriceData(prefix: "¥", money: 100, suffix: "元/次",discount: true), price2: PriceData(prefix: "会员¥", money: 80, suffix: "元/次",discount: true), price3: PriceData(prefix: "¥", money: 180, suffix: "元/6次",discount: true), price4: PriceData(prefix: "¥", money: 250, suffix: "元/12次",discount: true)),
    itemData(id: "F9428706-94C6-4944-BF1A-76036880044F", subcategoryId: "F9428706-94C6-4944-BF1A-76036800044F", title: "护理", subTitle: "Hair Cut", price1: PriceData(prefix: "¥", money: 100, suffix: "元/次",discount: true), price2: PriceData(prefix: "会员¥", money: 80, suffix: "元/次",discount: true), price3: PriceData(prefix: "¥", money: 180, suffix: "元/6次",discount: true), price4: PriceData(prefix: "¥", money: 250, suffix: "元/12次",discount: true)),
    
    
    itemData(id: "F9428706-94C6-4944-BF1A-76036880005F", subcategoryId: "F9428706-94C6-4944-BF1A-76036800005F", title: "头皮", subTitle: "Hair Cut", price1: PriceData(prefix: "¥", money: 100, suffix: "元/次",discount: true), price2: PriceData(prefix: "会员¥", money: 80, suffix: "元/次",discount: true), price3: PriceData(prefix: "¥", money: 180, suffix: "元/6次",discount: true), price4: PriceData(prefix: "¥", money: 250, suffix: "元/12次",discount: true)),
    itemData(id: "F9428706-94C6-4944-BF1A-76036880055F", subcategoryId: "F9428706-94C6-4944-BF1A-76036800055F", title: "头皮", subTitle: "Hair Cut", price1: PriceData(prefix: "¥", money: 100, suffix: "元/次",discount: true), price2: PriceData(prefix: "会员¥", money: 80, suffix: "元/次",discount: true), price3: PriceData(prefix: "¥", money: 180, suffix: "元/6次",discount: true), price4: PriceData(prefix: "¥", money: 250, suffix: "元/12次",discount: true)),
    
    
    itemData(id: "F9428706-94C6-4944-BF1A-76036880006F", subcategoryId: "F9428706-94C6-4944-BF1A-76036800006F", title: "美容", subTitle: "Hair Cut", price1: PriceData(prefix: "¥", money: 100, suffix: "元/次",discount: true), price2: PriceData(prefix: "会员¥", money: 80, suffix: "元/次",discount: true), price3: PriceData(prefix: "¥", money: 180, suffix: "元/6次",discount: true), price4: PriceData(prefix: "¥", money: 250, suffix: "元/12次",discount: true)),
    itemData(id: "F9428706-94C6-4944-BF1A-76036880066F", subcategoryId: "F9428706-94C6-4944-BF1A-76036800066F", title: "美容", subTitle: "Hair Cut", price1: PriceData(prefix: "¥", money: 100, suffix: "元/次",discount: true), price2: PriceData(prefix: "会员¥", money: 80, suffix: "元/次",discount: true), price3: PriceData(prefix: "¥", money: 180, suffix: "元/6次",discount: true), price4: PriceData(prefix: "¥", money: 250, suffix: "元/12次",discount: true))
]
