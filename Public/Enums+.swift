//
//  Enums+.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/5.
//

import Foundation
import SwiftUI

let ISPAD = UIDevice.current.userInterfaceIdiom == .pad


enum VipCardImage:String, CaseIterable{
    case card0 = "card0"
    case card1 = "card1"
    case card2 = "card2"
    case card3 = "card3"
    case card4 = "card4"
    case card5 = "card5"
    
    var string:String{
        switch self {
        case .card0:
            VipCardImage.card0.rawValue
        case .card1:
            VipCardImage.card1.rawValue
        case .card2:
            VipCardImage.card2.rawValue
        case .card3:
            VipCardImage.card3.rawValue
        case .card4:
            VipCardImage.card4.rawValue
        case .card5:
            VipCardImage.card5.rawValue
        }
    }
}
