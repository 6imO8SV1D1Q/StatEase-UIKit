//
//  Lesson.swift
//  StatEase-UIKit
//
//  Created by Claude Code
//

import Foundation

/// レッスン
struct Lesson: Codable {
    let id: String
    let title: String
    let description: String
    let thumbnailName: String?
    let difficulty: String
    let estimatedMinutes: Int
    let steps: [Step]
    let quizId: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case thumbnailName = "thumbnail_name"
        case difficulty
        case estimatedMinutes = "estimated_minutes"
        case steps
        case quizId = "quiz_id"
    }
}
