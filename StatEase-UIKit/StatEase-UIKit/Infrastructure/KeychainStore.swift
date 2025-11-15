//
//  KeychainStore.swift
//  StatEase-UIKit
//
//  Created by Claude Code
//

import Foundation
import Security

/// Keychain関連のエラー
enum KeychainError: Error {
    case saveFailed(OSStatus)
    case loadFailed(OSStatus)
    case deleteFailed(OSStatus)
    case dataConversionFailed
}

/// Keychainへのアクセスを管理するクラス
class KeychainStore {

    // MARK: - Singleton

    static let shared = KeychainStore()

    private init() {}

    // MARK: - Constants

    private let service = "com.statease.uikit"
    private let apiKeyAccount = "openai_api_key"

    // MARK: - Public Methods

    /// APIキーをKeychainに保存する
    /// - Parameter apiKey: 保存するAPIキー
    /// - Throws: KeychainError
    func saveAPIKey(_ apiKey: String) throws {
        guard let data = apiKey.data(using: .utf8) else {
            throw KeychainError.dataConversionFailed
        }

        // 既存のアイテムを削除（上書き保存のため）
        try? deleteAPIKey()

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: apiKeyAccount,
            kSecValueData as String: data
        ]

        let status = SecItemAdd(query as CFDictionary, nil)

        guard status == errSecSuccess else {
            throw KeychainError.saveFailed(status)
        }
    }

    /// KeychainからAPIキーを取得する
    /// - Returns: APIキー（存在しない場合はnil）
    /// - Throws: KeychainError
    func loadAPIKey() throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: apiKeyAccount,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        if status == errSecItemNotFound {
            return nil
        }

        guard status == errSecSuccess else {
            throw KeychainError.loadFailed(status)
        }

        guard let data = result as? Data,
              let apiKey = String(data: data, encoding: .utf8) else {
            throw KeychainError.dataConversionFailed
        }

        return apiKey
    }

    /// KeychainからAPIキーを削除する
    /// - Throws: KeychainError
    func deleteAPIKey() throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: apiKeyAccount
        ]

        let status = SecItemDelete(query as CFDictionary)

        // アイテムが存在しない場合はエラーとしない
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.deleteFailed(status)
        }
    }

    /// APIキーが設定されているかどうかを確認
    /// - Returns: 設定されている場合true
    func hasAPIKey() -> Bool {
        return (try? loadAPIKey()) != nil
    }
}
