//
//  Quiz.swift
//  StatEase-UIKit
//
//  Created by Claude Code
//

import Foundation

/// クイズの選択肢
struct QuizOption: Codable {
    let id: String
    let text: String
    let isCorrect: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case text
        case isCorrect = "is_correct"
    }
}

/// クイズの問題
struct QuizQuestion: Codable {
    let id: String
    let question: String
    let options: [QuizOption]
    let explanation: String
    let order: Int
}

/// クイズ
struct Quiz: Codable {
    let id: String
    let title: String
    let description: String
    let questions: [QuizQuestion]
}
