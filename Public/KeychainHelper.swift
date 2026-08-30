//
//  KeychainHelper.swift
//  pushme
//
//  Created by lynn on 2025/9/22.
//

import Foundation
import Security

final class KeychainHelper {
    static let shared = KeychainHelper()
    private init() {}

    private let service = Bundle.main.bundleIdentifier ?? "com.uuneo.menus"
    private let account = "MENUSDEVICEID"
    private let memberTokenAccount = "MEMBERTOKEN"

    // 读取设备唯一ID，如果不存在则创建并保存一个新的 UUID
    func getDeviceID(_ newData: Bool = false) -> String {
        if !newData {
            if let id = read() {
                return id
            }
        }
        let newID = replaceFoursWithRandomLetters(in: UUID().uuidString.replacingOccurrences(
            of: "-",
            with: ""
        ))
        save(newID)
        return newID
    }

    private func save(_ id: String, account: String? = nil) {
        guard let data = id.data(using: .utf8) else { return }
        let acc = account ?? self.account
        // 先删除旧数据，防止重复
        let queryDelete: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: acc,
        ]
        SecItemDelete(queryDelete as CFDictionary)

        // 添加新数据
        let queryAdd: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: acc,
            kSecValueData as String: data,
        ]
        SecItemAdd(queryAdd as CFDictionary, nil)
    }

    private func read(account: String? = nil) -> String? {
        let acc = account ?? self.account
        let queryRead: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: acc,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(queryRead as CFDictionary, &result)
        if status == errSecSuccess, let data = result as? Data,
           let id = String(data: data, encoding: .utf8)
        {
            return id
        }
        return nil
    }

    // MARK: - 会员系统 token

    func saveMemberToken(_ token: String) {
        save(token, account: memberTokenAccount)
    }

    func memberToken() -> String? {
        read(account: memberTokenAccount)
    }

    func clearMemberToken() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: memberTokenAccount,
        ]
        SecItemDelete(query as CFDictionary)
    }

    private func replaceFoursWithRandomLetters(in uuid: String) -> String {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ123567890"
        var result = ""

        for char in uuid {
            if char == "4" {
                // 随机取一个字母替换
                if let randomLetter = letters.randomElement() {
                    result.append(randomLetter)
                } else {
                    result.append(char) // 备用，理论不会到这
                }
            } else {
                result.append(char)
            }
        }
        return result.lowercased()
    }
}
