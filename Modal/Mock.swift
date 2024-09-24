//
//  Mock.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/16.
//

import Foundation



let MemberCardDataS = [
	MemberCardData( id: "A9428706-94C6-4944-BF1A-76036895818A",title: String(localized: "钻卡"), subTitle: String(localized: "Diamond Card"), money: 20000, name:String(localized:  "3折"), discount: 0.3, discount2: 0.7, image: "peacock1",footer: String(localized: "1. 课程折扣7折\n2. 卡诗洗发水")),
	MemberCardData(id: "B9428706-94C6-4944-BF1A-76036895818B",title: String(localized: "金卡"), subTitle: String(localized: "Gold Card"), money: 15000, name: String(localized: "6折"), discount: 0.6, discount2: 0.8, image: "peacock2",footer: String(localized: "1. 课程折扣8折")),
	MemberCardData(id: "C9428706-94C6-4944-BF1A-76036895818C",title: String(localized: "银卡"), subTitle: String(localized: "Silver Card"), money: 10000, name: String(localized: "7折"), discount: 0.7, discount2: 0.9, image: "peacock3",footer:String(localized:  "1. 课程折扣8折")),
	MemberCardData(id: "D9428706-94C6-4944-BF1A-76036895818D",title: String(localized: "普卡"), subTitle: String(localized: "Basic Card"), money: 5000, name: String(localized: "8折"), discount: 0.8, discount2: 1, image: "peacock6",footer: String(localized: " 会员优先服务")),
	MemberCardData(id: "E9428706-94C6-4944-BF1A-76036895818E",title: String(localized: "普卡"), subTitle: String(localized: "Basic Card"), money: 2000, name: String(localized: "8折"), discount: 0.9, discount2: 1, image: "peacock6",footer: String(localized: " 会员优先服务"))
]


let CategoryDataS = [
	CategoryData(id: "F9428706-94C6-4944-BF1A-76036895818F",title: String(localized: "基础篇"), subTitle: String(localized: "Hair Cut Chapter"), image: "haircut", color: "background11"),
	CategoryData(id: "G9428706-94C6-4944-BF1A-76036895818G",title: String(localized: "烫发篇"), subTitle: String(localized: "Perming Chapter"), image: "hairperm", color: "background3"),
	CategoryData(id: "H9428706-94C6-4944-BF1A-76036895818H",title: String(localized: "染发篇"), subTitle: String(localized: "Hair Dyeing Chapter"), image: "haircolors", color: "background4"),
	CategoryData(id: "J9428706-94C6-4944-BF1A-76036895818J",title: String(localized: "护理篇"), subTitle: String(localized: "Hair Care Chapter"), image: "haircare", color: "background7"),
	CategoryData(id: "K9428706-94C6-4944-BF1A-76036895818K",title: String(localized: "头皮健康"), subTitle: String(localized: "Scalp Care Chapter"), image: "headcare", color: "background8"),
	CategoryData(id: "L9428706-94C6-4944-BF1A-76036895818L",title: String(localized: "美容篇"), subTitle: String(localized: "Beauty Chapter"), image: "beauty", color: "background9")
]

let SubCategoryDataS = [
	SubCategoryData(id: "F9428706-94C6-4944-BF1A-76036800001F", categoryId: "F9428706-94C6-4944-BF1A-76036895818F", title: String(localized: "总监"), subTitle: String(localized: "DIRECTORS"), footer: ""),
	SubCategoryData(id: "F9428706-94C6-4944-BF1A-76036800011F", categoryId: "F9428706-94C6-4944-BF1A-76036895818F", title: String(localized: "首席"), subTitle: String(localized: "DIRECTORS"), footer: ""),
	
	SubCategoryData(id: "F9428706-94C6-4944-BF1A-76036800002F",categoryId: "G9428706-94C6-4944-BF1A-76036895818G", title: String(localized: "菲灵"), subTitle: String(localized: "Perming"), footer: ""),
	SubCategoryData(id: "F9428706-94C6-4944-BF1A-76036800022F",categoryId: "G9428706-94C6-4944-BF1A-76036895818G", title: String(localized: "威娜"), subTitle: String(localized: "Perming"), footer: ""),
	
	
	SubCategoryData(id: "F9428706-94C6-4944-BF1A-76036800003F",categoryId:  "H9428706-94C6-4944-BF1A-76036895818H",  title: String(localized: "菲灵"), subTitle: String(localized: "Hair Dyeing"), footer: ""),
	SubCategoryData(id: "F9428706-94C6-4944-BF1A-76036800033F",categoryId:  "H9428706-94C6-4944-BF1A-76036895818H",  title: String(localized: "威娜"), subTitle: String(localized: "Hair Dyeing"), footer: ""),
	
	
	
	
	SubCategoryData(id: "F9428706-94C6-4944-BF1A-76036800004F",categoryId: "J9428706-94C6-4944-BF1A-76036895818J",  title: String(localized: "菲灵"), subTitle: String(localized: "Hair Care"), footer: ""),
	SubCategoryData(id: "F9428706-94C6-4944-BF1A-76036800044F",categoryId: "J9428706-94C6-4944-BF1A-76036895818J",  title: String(localized: "威娜"), subTitle: String(localized: "Hair Care"), footer: ""),
	
	
	SubCategoryData(id: "F9428706-94C6-4944-BF1A-76036800005F",categoryId: "K9428706-94C6-4944-BF1A-76036895818K", title: String(localized: "菲灵"), subTitle: String(localized: "Scalp Care"), footer: ""),
	SubCategoryData(id: "F9428706-94C6-4944-BF1A-76036800055F", categoryId: "K9428706-94C6-4944-BF1A-76036895818K", title: String(localized: "卡彼"), subTitle: String(localized: "Scalp Care"), footer: ""),
	
	
	SubCategoryData(id: "F9428706-94C6-4944-BF1A-76036800006F", categoryId: "L9428706-94C6-4944-BF1A-76036895818L",title: String(localized: "身体"), subTitle: String(localized: "Beauty"), footer: ""),
	SubCategoryData(id: "F9428706-94C6-4944-BF1A-76036800066F", categoryId: "L9428706-94C6-4944-BF1A-76036895818L",title: String(localized: "面部"), subTitle: String(localized: "Beauty"), footer: "")
	
]

let ItemDataS = [
	
	
	
	
	ItemData(id: "F9428706-94C6-4944-BF1A-76036880001F",categoryId:  "F9428706-94C6-4944-BF1A-76036895818F", subcategoryId: "F9428706-94C6-4944-BF1A-76036800001F", title: String(localized: "剪发"), subTitle: String(localized: "Hair Cut"), price1: PriceData(prefix: "¥", money: 100, suffix: String(localized:"元/次"),discount: true), price2: PriceData(prefix:String(localized:"会员¥"), money: 80, suffix: String(localized:"元/次"),discount: true), price3: PriceData(prefix: "¥", money: 180, suffix: String(localized:"元/6次"),discount: true), price4: PriceData(prefix: "¥", money: 250, suffix: String(localized:"元/12次"),discount: true)),
	ItemData(id: "F9428706-94C6-4944-BF1A-76036880011F",categoryId:  "F9428706-94C6-4944-BF1A-76036895818F", subcategoryId: "F9428706-94C6-4944-BF1A-76036800001F", title: String(localized: "造型"), subTitle: String(localized: "Hair Cut"), price1: PriceData(prefix: "¥", money: 100, suffix: String(localized:"元/次"),discount: true), price2: PriceData(prefix:String(localized:"会员¥"), money: 80, suffix: String(localized:"元/次"),discount: true), price3: PriceData(prefix: "¥", money: 180, suffix: String(localized:"元/6次"),discount: true), price4: PriceData(prefix: "¥", money: 250, suffix: String(localized:"元/12次"), discount: true)),
	ItemData(id: "F9428706-94C6-4944-BF1A-76036881001F",categoryId:  "F9428706-94C6-4944-BF1A-76036895818F", subcategoryId: "F9428706-94C6-4944-BF1A-76036800011F", title: String(localized: "剪发"), subTitle: String(localized: "Hair Cut"), price1: PriceData(prefix: "¥", money: 100, suffix: String(localized:"元/次"),discount: true), price2: PriceData(prefix:String(localized:"会员¥"), money: 80, suffix: String(localized:"元/次"),discount: true), price3: PriceData(prefix: "¥", money: 180, suffix: String(localized:"元/6次"),discount: true), price4: PriceData(prefix: "¥", money: 250, suffix: String(localized:"元/12次"),discount: true)),
	ItemData(id: "F9428706-94C6-4944-BF1A-76036880111F",categoryId:  "F9428706-94C6-4944-BF1A-76036895818F", subcategoryId: "F9428706-94C6-4944-BF1A-76036800011F", title: String(localized: "造型"), subTitle: String(localized: "Hair Cut"), price1: PriceData(prefix: "¥", money: 100, suffix: String(localized:"元/次"),discount: true), price2: PriceData(prefix:String(localized:"会员¥"), money: 80, suffix: String(localized:"元/次"),discount: true), price3: PriceData(prefix: "¥", money: 180, suffix: String(localized:"元/6次"),discount: true), price4: PriceData(prefix: "¥", money: 250, suffix: String(localized:"元/12次"),discount: true)),
	ItemData(id: "F9428706-94C6-4944-BF1A-76036880002F",categoryId:  "G9428706-94C6-4944-BF1A-76036895818G", subcategoryId: "F9428706-94C6-4944-BF1A-76036800002F", title: String(localized: "烫发"), subTitle: String(localized: "Hair Cut"), price1: PriceData(prefix: "¥", money: 100, suffix: String(localized:"元/次"),discount: true), price2: PriceData(prefix:String(localized:"会员¥"), money: 80, suffix: String(localized:"元/次"),discount: true), price3: PriceData(prefix: "¥", money: 180, suffix: String(localized:"元/6次"),discount: true), price4: PriceData(prefix: "¥", money: 250, suffix: String(localized:"元/12次"),discount: true)),
	ItemData(id: "F9428706-94C6-4944-BF1A-76036880022F",categoryId:  "G9428706-94C6-4944-BF1A-76036895818G", subcategoryId: "F9428706-94C6-4944-BF1A-76036800022F", title: String(localized: "烫发"), subTitle: String(localized: "Hair Cut"), price1: PriceData(prefix: "¥", money: 100, suffix: String(localized:"元/次"),discount: true), price2: PriceData(prefix:String(localized:"会员¥"), money: 80, suffix: String(localized:"元/次"),discount: true), price3: PriceData(prefix: "¥", money: 180, suffix: String(localized:"元/6次"),discount: true), price4: PriceData(prefix: "¥", money: 250, suffix: String(localized:"元/12次"),discount: true)),
	ItemData(id: "F9428706-94C6-4944-BF1A-76036880003F",categoryId:  "H9428706-94C6-4944-BF1A-76036895818H", subcategoryId: "F9428706-94C6-4944-BF1A-76036800003F", title: String(localized: "染发"), subTitle: String(localized: "Hair Cut"), price1: PriceData(prefix: "¥", money: 100, suffix: String(localized:"元/次"),discount: true), price2: PriceData(prefix:String(localized:"会员¥"), money: 80, suffix: String(localized:"元/次"),discount: true), price3: PriceData(prefix: "¥", money: 180, suffix: String(localized:"元/6次"),discount: true), price4: PriceData(prefix: "¥", money: 250, suffix: String(localized:"元/12次"),discount: true)),
	ItemData(id: "F9428706-94C6-4944-BF1A-76036880033F",categoryId:  "H9428706-94C6-4944-BF1A-76036895818H", subcategoryId: "F9428706-94C6-4944-BF1A-76036800033F", title: String(localized: "染发"), subTitle: String(localized: "Hair Cut"), price1: PriceData(prefix: "¥", money: 100, suffix: String(localized:"元/次"),discount: true), price2: PriceData(prefix:String(localized:"会员¥"), money: 80, suffix: String(localized:"元/次"),discount: true), price3: PriceData(prefix: "¥", money: 180, suffix: String(localized:"元/6次"),discount: true), price4: PriceData(prefix: "¥", money: 250, suffix: String(localized:"元/12次"),discount: true)),
	ItemData(id: "F9428706-94C6-4944-BF1A-76036880004F",categoryId:  "J9428706-94C6-4944-BF1A-76036895818J", subcategoryId: "F9428706-94C6-4944-BF1A-76036800004F", title: String(localized: "护理"), subTitle: String(localized: "Hair Cut"), price1: PriceData(prefix: "¥", money: 100, suffix: String(localized:"元/次"),discount: true), price2: PriceData(prefix:String(localized:"会员¥"), money: 80, suffix: String(localized:"元/次"),discount: true), price3: PriceData(prefix: "¥", money: 180, suffix: String(localized:"元/6次"),discount: true), price4: PriceData(prefix: "¥", money: 250, suffix: String(localized:"元/12次"),discount: true)),
	ItemData(id: "F9428706-94C6-4944-BF1A-76036880044F",categoryId:  "J9428706-94C6-4944-BF1A-76036895818J", subcategoryId: "F9428706-94C6-4944-BF1A-76036800044F", title: String(localized: "护理"), subTitle: String(localized: "Hair Cut"), price1: PriceData(prefix: "¥", money: 100, suffix: String(localized:"元/次"),discount: true), price2: PriceData(prefix:String(localized:"会员¥"), money: 80, suffix: String(localized:"元/次"),discount: true), price3: PriceData(prefix: "¥", money: 180, suffix: String(localized:"元/6次"),discount: true), price4: PriceData(prefix: "¥", money: 250, suffix: String(localized:"元/12次"),discount: true)),
	ItemData(id: "F9428706-94C6-4944-BF1A-76036880005F",categoryId:  "K9428706-94C6-4944-BF1A-76036895818K", subcategoryId: "F9428706-94C6-4944-BF1A-76036800005F", title: String(localized: "头皮"), subTitle: String(localized: "Hair Cut"), price1: PriceData(prefix: "¥", money: 100, suffix: String(localized:"元/次"),discount: true), price2: PriceData(prefix:String(localized:"会员¥"), money: 80, suffix: String(localized:"元/次"),discount: true), price3: PriceData(prefix: "¥", money: 180, suffix: String(localized:"元/6次"),discount: true), price4: PriceData(prefix: "¥", money: 250, suffix: String(localized:"元/12次"),discount: true)),
	ItemData(id: "F9428706-94C6-4944-BF1A-76036880055F",categoryId:  "K9428706-94C6-4944-BF1A-76036895818K", subcategoryId: "F9428706-94C6-4944-BF1A-76036800055F", title: String(localized: "头皮"), subTitle: String(localized: "Hair Cut"), price1: PriceData(prefix: "¥", money: 100, suffix: String(localized:"元/次"),discount: true), price2: PriceData(prefix:String(localized:"会员¥"), money: 80, suffix: String(localized:"元/次"),discount: true), price3: PriceData(prefix: "¥", money: 180, suffix: String(localized:"元/6次"),discount: true), price4: PriceData(prefix: "¥", money: 250, suffix: String(localized:"元/12次"),discount: true)),
	ItemData(id: "F9428706-94C6-4944-BF1A-76036880006F",categoryId:  "L9428706-94C6-4944-BF1A-76036895818L", subcategoryId: "F9428706-94C6-4944-BF1A-76036800006F", title: String(localized: "美容"), subTitle: String(localized: "Hair Cut"), price1: PriceData(prefix: "¥", money: 100, suffix: String(localized:"元/次"),discount: true), price2: PriceData(prefix:String(localized:"会员¥"), money: 80, suffix: String(localized:"元/次"),discount: true), price3: PriceData(prefix: "¥", money: 180, suffix: String(localized:"元/6次"),discount: true), price4: PriceData(prefix: "¥", money: 250, suffix: String(localized:"元/12次"),discount: true)),
	ItemData(id: "F9428706-94C6-4944-BF1A-76036880066F", categoryId:  "L9428706-94C6-4944-BF1A-76036895818L", subcategoryId: "F9428706-94C6-4944-BF1A-76036800066F", title: String(localized: "美容"), subTitle:String(localized:  "Hair Cut"), price1: PriceData(prefix: "¥", money: 100, suffix:String(localized: "元/次"),discount: true), price2: PriceData(prefix: String(localized:"会员¥"), money: 80, suffix: String(localized:"元/次"),discount: true), price3: PriceData(prefix: "¥", money: 180, suffix: String(localized:"元/6次"),discount: true), price4: PriceData(prefix: "¥", money: 250, suffix: String(localized:"元/12次"),discount: true))
]
