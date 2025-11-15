//
//  KeychainStore.swift
//  StatEase-UIKit
//
//  Created by Claude Code
//

import Foundation
import Security

/// Keychainを使ったAPIキー保存
class KeychainStore {
    static let shared = KeychainStore()

    private let service = "com.statease.uikit"
    private let apiKeyAccount = "openai_api_key"

    private init() {}

    /// APIキーを保存
    func saveAPIKey(_ apiKey: String) -> Bool {
        // 既存のキーを削除
        deleteAPIKey()

        guard let data = apiKey.data(using: .utf8) else {
            return false
        }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: apiKeyAccount,
            kSecValueData as String: data
        ]

        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    /// APIキーを取得
    func fetchAPIKey() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: apiKeyAccount,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess,
              let data = result as? Data,
              let apiKey = String(data: data, encoding: .utf8) else {
            return nil
        }

        return apiKey
    }

    /// APIキーを削除
    func deleteAPIKey() -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: apiKeyAccount
        ]

        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }

    /// APIキーが保存されているか確認
    func hasAPIKey() -> Bool {
        return fetchAPIKey() != nil
    }
}
