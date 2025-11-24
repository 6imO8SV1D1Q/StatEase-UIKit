//
//  Step.swift
//  StatEase-UIKit
//
//  Created by Claude Code
//

import Foundation

/// メディア情報
struct StepMedia: Codable {
    let type: String  // "image" or "video"
    let assetName: String
    let caption: String?

    enum CodingKeys: String, CodingKey {
        case type
        case assetName = "asset_name"
        case caption
    }
}

/// チェックポイント（理解度確認）
struct StepCheckpoint: Codable {
    let prompt: String
    let expectedAnswer: String

    enum CodingKeys: String, CodingKey {
        case prompt
        case expectedAnswer = "expected_answer"
    }
}

/// レッスンの1ステップ（公式JSONフォーマットv1.0対応）
struct Step: Codable {
    let id: String
    let order: Int
    let type: StepType
    let title: String
    let body: String
    let paragraphs: [StepParagraph]?
    let media: StepMedia?
    let checkpoint: StepCheckpoint?

    enum CodingKeys: String, CodingKey {
        case id
        case order
        case type
        case title
        case body
        case paragraphs
        case media
        case checkpoint
    }
}

struct StepParagraph: Codable {
    let title: String?
    let body: String
}
