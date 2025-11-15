//
//  Lesson.swift
//  StatEase-UIKit
//
//  Created by Claude Code
//

import Foundation

/// リソース情報
struct LessonResources: Codable {
    let keyTerms: [String]
    let externalLinks: [ExternalLink]?

    enum CodingKeys: String, CodingKey {
        case keyTerms = "key_terms"
        case externalLinks = "external_links"
    }
}

/// 外部リンク
struct ExternalLink: Codable {
    let title: String
    let url: String
}

/// レッスン（公式JSONフォーマットv1.0対応）
struct Lesson: Codable {
    let id: String
    let title: String
    let subtitle: String
    let estimatedMinutes: Int
    let topic: String
    let summary: String
    let learningObjectives: [String]
    let prerequisites: [String]
    let steps: [Step]
    let resources: LessonResources

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case subtitle
        case estimatedMinutes = "estimated_minutes"
        case topic
        case summary
        case learningObjectives = "learning_objectives"
        case prerequisites
        case steps
        case resources
    }
}
