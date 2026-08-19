//
//  AppDelegate.swift
//  PeacockMenus
//
//  Created by Neo on 2025/11/25.
//

import AppIntents
import Defaults
import Foundation
import PushKit
import RealmSwift
import SwiftUI
import SwiftyJSON
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func setupRealm() {
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = kRealmDefaultConfiguration

        #if DEBUG

        let realm = try? Realm()
        debugPrint("message count: \(realm?.objects(CategoryRealmData.self).count ?? 0)")
        #endif
    }

    func application(
        _: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        debugPrint(token)
        Defaults[.deviceToken] = token
    }

    func application(_: UIApplication, didFailToRegisterForRemoteNotificationsWithError _: Error) {
        // MARK: 处理注册失败的情况
    }

    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        /// 配置数据库
        setupRealm()

        UNUserNotificationCenter.current().delegate = self

        return true
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let content = response.notification.request.content
        notificatonHandler(userInfo: content.userInfo)

        // 清除通知中心的显示
        center.removeDeliveredNotifications(withIdentifiers: [content.threadIdentifier])

        completionHandler()
    }

    // 处理应用程序在前台是否显示通知
    func userNotificationCenter(
        _: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
            -> Void
    ) {
        if notification.request.content.interruptionLevel.rawValue > 1 {
            completionHandler(.banner)
        } else {
            completionHandler(.badge)
        }

        notificatonHandler(userInfo: notification.request.content.userInfo)
    }

    func notificatonHandler(userInfo _: [AnyHashable: Any]) {}

    func userNotificationCenter(_: UNUserNotificationCenter, openSettingsFor _: UNNotification?) {
//        AppManager.shared.page = .setting
//        AppManager.shared.router = [.more]
    }
}
