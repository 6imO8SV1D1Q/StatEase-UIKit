//
//  StepType.swift
//  StatEase-UIKit
//
//  Created by Claude Code
//

import Foundation

/// ステップの種類
enum StepType: String, Codable {
    case text       // テキストのみ
    case image      // 画像付き
    case video      // 動画付き
    case formula    // 数式付き
}
