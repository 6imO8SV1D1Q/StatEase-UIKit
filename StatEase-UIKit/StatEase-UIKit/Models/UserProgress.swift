//
//  UserProgress.swift
//  StatEase-UIKit
//
//  Created by Claude Code
//

import Foundation

/// ユーザーの学習進捗
struct UserProgressRecord: Codable {
    let lessonId: String
    var completedSteps: Set<String>
    var isCompleted: Bool
    var lastAccessedDate: Date
    var quizScore: Int?
    var isQuizCompleted: Bool

    enum CodingKeys: String, CodingKey {
        case lessonId = "lesson_id"
        case completedSteps = "completed_steps"
        case isCompleted = "is_completed"
        case lastAccessedDate = "last_accessed_date"
        case quizScore = "quiz_score"
        case isQuizCompleted = "is_quiz_completed"
    }

    init(lessonId: String) {
        self.lessonId = lessonId
        self.completedSteps = []
        self.isCompleted = false
        self.lastAccessedDate = Date()
        self.quizScore = nil
        self.isQuizCompleted = false
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        lessonId = try container.decode(String.self, forKey: .lessonId)
        completedSteps = try container.decodeIfPresent(Set<String>.self, forKey: .completedSteps) ?? []
        isCompleted = try container.decodeIfPresent(Bool.self, forKey: .isCompleted) ?? false
        lastAccessedDate = try container.decodeIfPresent(Date.self, forKey: .lastAccessedDate) ?? Date()
        quizScore = try container.decodeIfPresent(Int.self, forKey: .quizScore)
        isQuizCompleted = try container.decodeIfPresent(Bool.self, forKey: .isQuizCompleted) ?? false
    }
}

/// ユーザーの進捗状態を管理するシングルトン
final class UserProgress {

    static let shared = UserProgress()

    private let store: UserDefaultsStore

    init(store: UserDefaultsStore = .shared) {
        self.store = store
    }

    func isLessonCompleted(lessonId: String) -> Bool {
        store.fetchProgress(for: lessonId)?.isCompleted ?? false
    }

    func markLessonCompleted(lessonId: String) {
        updateProgress(lessonId: lessonId) { progress in
            progress.isCompleted = true
            progress.lastAccessedDate = Date()
        }
    }

    func resetLessonCompletion(lessonId: String) {
        updateProgress(lessonId: lessonId) { progress in
            progress.isCompleted = false
            progress.completedSteps.removeAll()
            progress.lastAccessedDate = Date()
        }
    }

    func isQuizCompleted(lessonId: String) -> Bool {
        store.fetchProgress(for: lessonId)?.isQuizCompleted ?? false
    }

    func markQuizCompleted(lessonId: String) {
        updateProgress(lessonId: lessonId) { progress in
            progress.isQuizCompleted = true
            progress.lastAccessedDate = Date()
        }
    }

    func resetQuizCompletion(lessonId: String) {
        updateProgress(lessonId: lessonId) { progress in
            progress.isQuizCompleted = false
            progress.quizScore = nil
            progress.lastAccessedDate = Date()
        }
    }

    func resetAllProgress() {
        store.resetProgress()
    }

    private func updateProgress(lessonId: String, mutate: (inout UserProgressRecord) -> Void) {
        var progress = store.fetchProgress(for: lessonId) ?? UserProgressRecord(lessonId: lessonId)
        mutate(&progress)
        store.saveProgress(progress)
    }
}
