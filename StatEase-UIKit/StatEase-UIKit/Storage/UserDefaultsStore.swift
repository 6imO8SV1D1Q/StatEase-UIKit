//
//  UserDefaultsStore.swift
//  StatEase-UIKit
//
//  Created by Claude Code
//

import Foundation

/// UserDefaultsを使った進捗管理
class UserDefaultsStore {
    static let shared = UserDefaultsStore()

    private let defaults = UserDefaults.standard
    private let progressKey = "user_progress"

    private init() {}

    /// 進捗を保存
    func saveProgress(_ progress: UserProgress) {
        var allProgress = fetchAllProgress()

        // 既存の進捗を更新または新規追加
        if let index = allProgress.firstIndex(where: { $0.lessonId == progress.lessonId }) {
            allProgress[index] = progress
        } else {
            allProgress.append(progress)
        }

        // エンコードして保存
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        if let encoded = try? encoder.encode(allProgress) {
            defaults.set(encoded, forKey: progressKey)
        }
    }

    /// 特定のレッスンの進捗を取得
    func fetchProgress(for lessonId: String) -> UserProgress? {
        let allProgress = fetchAllProgress()
        return allProgress.first(where: { $0.lessonId == lessonId })
    }

    /// すべての進捗を取得
    func fetchAllProgress() -> [UserProgress] {
        guard let data = defaults.data(forKey: progressKey) else {
            return []
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        guard let progress = try? decoder.decode([UserProgress].self, from: data) else {
            return []
        }

        return progress
    }

    /// 進捗をリセット
    func resetProgress() {
        defaults.removeObject(forKey: progressKey)
    }

    /// 特定のレッスンの進捗をリセット
    func resetProgress(for lessonId: String) {
        var allProgress = fetchAllProgress()
        allProgress.removeAll(where: { $0.lessonId == lessonId })

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        if let encoded = try? encoder.encode(allProgress) {
            defaults.set(encoded, forKey: progressKey)
        }
    }
}
