//
//  UserProgress.swift
//  StatEase-UIKit
//
//  Created by Claude Code
//

import Foundation

/// ユーザーの学習進捗を管理するクラス
/// UserDefaultsへのアクセスをラップする
class UserProgress {

    // MARK: - Singleton
    static let shared = UserProgress()

    private let userDefaults = UserDefaults.standard

    private init() {}

    // MARK: - Keys
    private func lessonCompletedKey(lessonId: String) -> String {
        return "lesson_completed_\(lessonId)"
    }

    private func quizCompletedKey(lessonId: String) -> String {
        return "quiz_completed_\(lessonId)"
    }

    // MARK: - Lesson Completion

    /// レッスンを完了としてマークする
    /// - Parameter lessonId: レッスンID
    func markLessonCompleted(lessonId: String) {
        userDefaults.set(true, forKey: lessonCompletedKey(lessonId: lessonId))
    }

    /// レッスンが完了しているかどうかを確認
    /// - Parameter lessonId: レッスンID
    /// - Returns: 完了している場合true
    func isLessonCompleted(lessonId: String) -> Bool {
        return userDefaults.bool(forKey: lessonCompletedKey(lessonId: lessonId))
    }

    /// レッスンの完了状態をリセット
    /// - Parameter lessonId: レッスンID
    func resetLessonCompletion(lessonId: String) {
        userDefaults.removeObject(forKey: lessonCompletedKey(lessonId: lessonId))
    }

    // MARK: - Quiz Completion

    /// 確認問題を完了としてマークする
    /// - Parameter lessonId: レッスンID
    func markQuizCompleted(lessonId: String) {
        userDefaults.set(true, forKey: quizCompletedKey(lessonId: lessonId))
    }

    /// 確認問題が完了しているかどうかを確認
    /// - Parameter lessonId: レッスンID
    /// - Returns: 完了している場合true
    func isQuizCompleted(lessonId: String) -> Bool {
        return userDefaults.bool(forKey: quizCompletedKey(lessonId: lessonId))
    }

    /// 確認問題の完了状態をリセット
    /// - Parameter lessonId: レッスンID
    func resetQuizCompletion(lessonId: String) {
        userDefaults.removeObject(forKey: quizCompletedKey(lessonId: lessonId))
    }

    // MARK: - Reset All

    /// すべての進捗をリセット（デバッグ用）
    func resetAllProgress() {
        let dictionary = userDefaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            if key.hasPrefix("lesson_completed_") || key.hasPrefix("quiz_completed_") {
                userDefaults.removeObject(forKey: key)
            }
        }
    }
}
