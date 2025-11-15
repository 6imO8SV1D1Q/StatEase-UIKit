//
//  Lesson.swift
//  StatEase-UIKit
//
//  Created by Claude Code
//

import Foundation

/// ステップの種類
enum StepType: String, Decodable {
    case text   // テキスト表示
    case image  // 静止画表示
    case video  // 動画表示
}

/// レッスン内の1ステップを表すモデル
struct Step: Decodable {
    let type: StepType
    let content: String?       // type == .text の場合に使用
    let file: String?          // type == .image or .video の場合に使用
    let description: String?   // 任意の説明（アクセシビリティ等で使用）
}

/// レッスン全体を表すモデル
struct Lesson: Decodable {
    let id: String
    let title: String
    let chapter: String
    let durationMinutes: Int
    let steps: [Step]
}
