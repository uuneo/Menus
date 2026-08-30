//
//  RealmConfig.swift
//  PeacockMenus
//
//  Created by Neo on 2025/11/25.
//

import Foundation
@_exported import RealmSwift

let CONTAINER = FileManager.default
    .containerURL(forSecurityApplicationGroupIdentifier: "group.PeacockMenus")

let kRealmDefaultConfiguration = Realm.Configuration(
    fileURL: CONTAINER?.appendingPathComponent("peacock"),
    schemaVersion: 4,
    migrationBlock: { _, oldSchemaVersion in
        if oldSchemaVersion < 4 {}
    }
)
