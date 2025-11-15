//
//  UserProgress.swift
//  StatEase-UIKit
//
//  Created by Claude Code
//

import Foundation

/// ユーザーの学習進捗
struct UserProgress: Codable {
    let lessonId: String
    var completedSteps: Set<String>
    var isCompleted: Bool
    var lastAccessedDate: Date
    var quizScore: Int?

    enum CodingKeys: String, CodingKey {
        case lessonId = "lesson_id"
        case completedSteps = "completed_steps"
        case isCompleted = "is_completed"
        case lastAccessedDate = "last_accessed_date"
        case quizScore = "quiz_score"
    }

    init(lessonId: String) {
        self.lessonId = lessonId
        self.completedSteps = []
        self.isCompleted = false
        self.lastAccessedDate = Date()
        self.quizScore = nil
    }
}
