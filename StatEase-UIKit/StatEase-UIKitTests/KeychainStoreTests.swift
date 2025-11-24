//
//  KeychainStoreTests.swift
//  StatEase-UIKitTests
//
//  Created by Claude Code
//

import XCTest
@testable import StatEase_UIKit

final class KeychainStoreTests: XCTestCase {

    let testAPIKey = "sk-test-1234567890abcdefghijklmnopqrstuvwxyz"

    override func setUp() {
        super.setUp()
        // テスト前にAPIキーをクリア
        try? KeychainStore.shared.deleteAPIKey()
    }

    override func tearDown() {
        // テスト後にクリーンアップ
        try? KeychainStore.shared.deleteAPIKey()
        super.tearDown()
    }

    // MARK: - Save Tests

    func testSaveAPIKey() throws {
        // APIキーを保存
        try KeychainStore.shared.saveAPIKey(testAPIKey)

        // 保存されたことを確認
        let loaded = try KeychainStore.shared.loadAPIKey()
        XCTAssertEqual(loaded, testAPIKey)
    }

    func testSaveAPIKeyOverwrite() throws {
        // 最初のAPIキーを保存
        try KeychainStore.shared.saveAPIKey("first_key")

        // 上書き保存
        try KeychainStore.shared.saveAPIKey(testAPIKey)

        // 新しいキーが保存されていることを確認
        let loaded = try KeychainStore.shared.loadAPIKey()
        XCTAssertEqual(loaded, testAPIKey)
    }

    // MARK: - Load Tests

    func testLoadAPIKeyWhenNotSet() throws {
        // APIキーが設定されていない場合
        let loaded = try KeychainStore.shared.loadAPIKey()
        XCTAssertNil(loaded)
    }

    func testLoadAPIKeyWhenSet() throws {
        // APIキーを保存
        try KeychainStore.shared.saveAPIKey(testAPIKey)

        // 読み込み
        let loaded = try KeychainStore.shared.loadAPIKey()
        XCTAssertEqual(loaded, testAPIKey)
    }

    // MARK: - Delete Tests

    func testDeleteAPIKey() throws {
        // APIキーを保存
        try KeychainStore.shared.saveAPIKey(testAPIKey)
        XCTAssertNotNil(try KeychainStore.shared.loadAPIKey())

        // 削除
        try KeychainStore.shared.deleteAPIKey()

        // 削除されたことを確認
        let loaded = try KeychainStore.shared.loadAPIKey()
        XCTAssertNil(loaded)
    }

    func testDeleteAPIKeyWhenNotSet() throws {
        // APIキーが設定されていない状態で削除してもエラーにならないことを確認
        XCTAssertNoThrow(try KeychainStore.shared.deleteAPIKey())
    }

    // MARK: - hasAPIKey Tests

    func testHasAPIKeyReturnsFalseWhenNotSet() {
        XCTAssertFalse(KeychainStore.shared.hasAPIKey())
    }

    func testHasAPIKeyReturnsTrueWhenSet() throws {
        try KeychainStore.shared.saveAPIKey(testAPIKey)
        XCTAssertTrue(KeychainStore.shared.hasAPIKey())
    }
}
