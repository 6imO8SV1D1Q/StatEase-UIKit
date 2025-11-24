//
//  Quiz.swift
//  StatEase-UIKit
//
//  Created by Claude Code
//

import Foundation

/// クイズの選択肢
struct QuizChoice: Codable {
    let id: String
    let text: String
    let isCorrect: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case text
        case isCorrect = "is_correct"
    }
}

/// クイズの問題（公式JSONフォーマットv1.0対応）
struct QuizQuestion: Codable {
    let id: String
    let order: Int
    let prompt: String
    let choices: [QuizChoice]
    let explanation: String
    let tags: [String]
}

/// クイズ（公式JSONフォーマットv1.0対応）
struct Quiz: Codable {
    let id: String
    let title: String
    let description: String
    let shuffle: Bool
    let timeLimitSeconds: Int?
    let questions: [QuizQuestion]

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case shuffle
        case timeLimitSeconds = "time_limit_seconds"
        case questions
    }
}
