//
//  GeminiModels.swift
//  StatEase-UIKit
//
//  Created by Claude Code
//

import Foundation

// Gemini API用のリクエスト/レスポンスモデル

struct GeminiRequest: Codable, Sendable {
    let contents: [GeminiContent]
    let generationConfig: GeminiGenerationConfig?

    struct GeminiContent: Codable, Sendable {
        let parts: [GeminiPart]
        let role: String?
    }

    struct GeminiPart: Codable, Sendable {
        let text: String
    }

    struct GeminiGenerationConfig: Codable, Sendable {
        let temperature: Double?
        let maxOutputTokens: Int?
    }
}

struct GeminiResponse: Codable, Sendable {
    let candidates: [GeminiCandidate]?
    let error: GeminiAPIError?

    struct GeminiCandidate: Codable, Sendable {
        let content: GeminiContent
        let finishReason: String?
    }

    struct GeminiContent: Codable, Sendable {
        let parts: [GeminiPart]?
        let role: String
    }

    struct GeminiPart: Codable, Sendable {
        let text: String
    }

    struct GeminiAPIError: Codable, Sendable {
        let message: String
        let code: Int?
    }
}
