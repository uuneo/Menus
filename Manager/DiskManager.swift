//
//  DiskManager.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/5.
//

import Alamofire
import Defaults
import Foundation
import JDStatusBarNotification
import RealmSwift
import SwiftUI

struct MemberUploadResult: Decodable {
    let code: Int
}

enum Page: String, Identifiable, CaseIterable, Defaults.Serializable, Equatable {
    case home = "house.circle"
    case setting = "gear.circle"
    case gift = "gift.circle"
    case deepseek = "sparkles"
    case calculator = "plus.forwardslash.minus"
    var id: String { rawValue }

    var name: String {
        switch self {
        case .home:
            String(localized: "价目表")
        case .setting:
            String(localized: "设置")
        case .gift:
            String(localized: "礼品")
        case .deepseek:
            String(localized: "智能助手")
        case .calculator:
            String(localized: "计算器")
        }
    }

    static let arr: [Self] = [.home, .deepseek, .calculator]
    static let backs: [Self] = [.home, .deepseek, .calculator, .setting]
}

@Observable
final class peacock{
    static let shared = peacock()

    private init() {}

    var selectCard = MemberCardRealmData.nonmember.id
    var selectVip: MemberCardRealmData?
    var page: Page = .deepseek
    var fullPage: Bool = false
    var showVipHairCourse = false

    var selectCardData: MemberCardRealmData {
        if let realm = try? Realm(),
           let data = realm
           .objects(MemberCardRealmData.self)
           .first(where: { $0.id == selectCard })
        {
            return data
        }
        return MemberCardRealmData.nonmember
    }
}

extension peacock {
    /// 登录会员系统后, 通过认证接口拉取价目表并导入(空数据不覆盖)
    func syncMenusFromMemberServer(token: String? = nil, completion: ((Bool) -> Void)? = nil) {
        let authToken = token ?? MemberAuth.shared.token
        guard MemberAuth.shared.isLoggedIn else {
            completion?(false)
            return
        }
        let headers: HTTPHeaders = ["Authorization": "Bearer \(authToken)"]
        var request = URLRequest(url: URL(string: MemberAuth.shared.baseURL + "/ios/menus")!)
        request.method = .get
        request.headers = headers
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.timeoutInterval = 15
        AF.request(request)
        .validate(statusCode: 200..<300)
        .responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let total = try JSONDecoder().decode(TotalRealmData.self, from: data)
                    guard !(total.Cards.isEmpty && total.Items.isEmpty) else {
                        debugPrint("价目表数据为空")
                        completion?(false)
                        return
                    }
                    Task {
                        await self.importData(totaldata: total)
                        completion?(true)
                    }
                } catch {
                    debugPrint("价目表解码失败:", error)
                    completion?(false)
                }
            case .failure(let error):
                debugPrint("价目表请求失败:", error)
                completion?(false)
            }
        }
    }

    /// 管理员上传价目表到会员服务器 /ios/menus
    func uploadMenusToMemberServer(token: String, completion: ((Bool) -> Void)? = nil) {
        guard let fileURL = saveJSONToTempFile(object: exportTotalData(), fileName: "menus"),
              MemberAuth.shared.isAdmin
        else {
            completion?(false)
            return
        }
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        AF.upload(
            multipartFormData: { $0.append(
                fileURL,
                withName: "file",
                fileName: fileURL.lastPathComponent,
                mimeType: "application/json"
            ) },
            to: MemberAuth.shared.baseURL + "/ios/menus",
            headers: headers
        )
        .responseDecodable(of: MemberUploadResult.self) { response in
            switch response.result {
            case .success(let result):
                completion?(result.code == 200)
            case .failure:
                completion?(false)
            }
        }
    }

    func exportTotalData() -> TotalRealmData? {
        // Defaults[.Cards] Defaults[.Categorys]
        guard let realm = try? Realm() else { return nil }

        let homeInfo = realm.objects(MenusHomeInfo.self).first

        return TotalRealmData(
            Cards: Array(realm.objects(MemberCardRealmData.self)),
            Categorys: Array(realm.objects(CategoryRealmData.self)),
            Subcategorys: Array(realm.objects(SubCategoryRealmData.self)),
            Items: Array(realm.objects(ItemRealmData.self)),
            menusName: homeInfo?.menusName, menusSubName: homeInfo?.menusSubName,
            menusFooter: homeInfo?.menusFooter, menusImage: homeInfo?.menusImage,
            homeCardTitle: homeInfo?.homeCardTitle,
            homeCardSubTitle: homeInfo?.homeCardSubTitle,
            homeItemsTitle: homeInfo?.homeItemsTitle,
            homeItemsSubTitle: homeInfo?.homeItemsSubTitle
        )
    }

    func exportData() -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        do {
            let data = try encoder.encode(exportTotalData())
            return String(data: data, encoding: .utf8)!
        } catch {
            debugPrint(error)
        }
        return nil
    }

    func saveJSONToTempFile<T: Encodable>(object: T, fileName: String) -> URL? {
        // 获取临时目录
        let tempDirectory = FileManager.default.temporaryDirectory

        // 创建临时文件的 URL
        let tempFileURL = tempDirectory.appendingPathComponent(fileName)
            .appendingPathExtension("json")

        do {
            // 创建 JSON 编码器
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
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

    @MainActor func importData(text: String) -> Bool {
        let decoder = JSONDecoder()
        let data = text.data(using: .utf8)!

        do {
            let totalData = try decoder.decode(TotalRealmData.self, from: data)
            importData(totaldata: totalData)
            return true
        } catch {
            debugPrint(error.localizedDescription)
            return false
        }
    }

    @MainActor func importData(totaldata: TotalRealmData) {
        let cards = totaldata.Cards
        let categorys = totaldata.Categorys
        let subcategorys = totaldata.Subcategorys
        let items = totaldata.Items

        guard let realm = try? Realm() else { return }

        if let searchApi = totaldata.searchApi {
            Defaults[.searchApi] = searchApi
        }

        if let searchAuth = totaldata.searchAuth {
            Defaults[.searchAuth] = searchAuth
        }

        try? realm.write {
            let homeInfo = realm.objects(MenusHomeInfo.self).first ?? MenusHomeInfo()

            if let title = totaldata.homeCardTitle {
                homeInfo.homeCardTitle = title
            }

            if let subTitle = totaldata.homeCardSubTitle {
                homeInfo.homeCardSubTitle = subTitle
            }

            if let itemTitle = totaldata.homeItemsTitle {
                homeInfo.homeItemsTitle = itemTitle
            }

            if let itemSubtitle = totaldata.homeItemsSubTitle {
                homeInfo.homeItemsSubTitle = itemSubtitle
            }

            if let menusName = totaldata.menusName {
                homeInfo.menusName = menusName
            }

            if let menusFooter = totaldata.menusFooter {
                homeInfo.menusFooter = menusFooter
            }

            if let menusImage = totaldata.menusImage {
                homeInfo.menusImage = menusImage
            }

            if let subName = totaldata.menusSubName {
                homeInfo.menusSubName = subName
            }

            realm.add(homeInfo, update: .all)
        }

        if !cards.isEmpty {
            try? realm.write {
                realm.delete(realm.objects(MemberCardRealmData.self))
            }
            try? realm.write {
                realm.add(cards, update: .all)
            }
        }

        if !categorys.isEmpty {
            try? realm.write {
                realm.delete(realm.objects(CategoryRealmData.self))
            }
            try? realm.write {
                realm.add(categorys, update: .all)
            }
        }

        if !subcategorys.isEmpty {
            try? realm.write {
                realm.delete(realm.objects(SubCategoryRealmData.self))
            }
            try? realm.write {
                realm.add(subcategorys, update: .all)
            }
        }

        if !items.isEmpty {
            try? realm.write {
                realm.delete(realm.objects(ItemRealmData.self))
            }
            try? realm.write {
                realm.add(items, update: .all)
            }
        }
    }

    @MainActor
    func toast(
        _ message: String,
        mode: IncludedStatusBarNotificationStyle = .defaultStyle,
        duration: Double = 1.6
    ) {
        // 状态栏通知必须在主线程调用
        if Thread.isMainThread {
            showToast(message, mode: mode, duration: duration)
        } else {
            DispatchQueue.main.async {
                self.showToast(message, mode: mode, duration: duration)
            }
        }
    }

    private func showToast(
        _ message: String,
        mode: IncludedStatusBarNotificationStyle,
        duration: Double
    ) {
        NotificationPresenter.shared
            .present(message, includedStyle: mode, duration: duration) { presenter in
                presenter.animateProgressBar(to: 1.0, duration: 0.75) { presenter in
                    presenter.dismiss()
                }
            }
    }
}


