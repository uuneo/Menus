//
//  PeacockProtocol.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/6.
//

import Foundation
import Defaults


protocol PeacockProtocol: Hashable,Equatable, Identifiable, Codable, Defaults.Serializable{ }

extension PeacockProtocol{
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs:  Self, rhs:  Self) -> Bool {
        return lhs.id == rhs.id
    }
    
}
