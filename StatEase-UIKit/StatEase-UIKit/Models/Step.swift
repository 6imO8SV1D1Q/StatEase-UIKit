//
//  Step.swift
//  StatEase-UIKit
//
//  Created by Claude Code
//

import Foundation

/// レッスンの1ステップ
struct Step: Codable {
    let id: String
    let type: StepType
    let title: String?
    let content: String
    let imageName: String?
    let videoName: String?
    let order: Int

    enum CodingKeys: String, CodingKey {
        case id
        case type
        case title
        case content
        case imageName = "image_name"
        case videoName = "video_name"
        case order
    }
}
