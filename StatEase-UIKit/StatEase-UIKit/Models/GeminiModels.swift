//
//  GeminiModels.swift
//  StatEase-UIKit
//
//  Created by Claude Code
//

import Foundation

// Gemini API用のリクエスト/レスポンスモデル

struct GeminiRequest: Codable {
    let contents: [GeminiContent]
    let generationConfig: GeminiGenerationConfig?

    struct GeminiContent: Codable {
        let parts: [GeminiPart]
        let role: String?
    }

    struct GeminiPart: Codable {
        let text: String
    }

    struct GeminiGenerationConfig: Codable {
        let temperature: Double?
        let maxOutputTokens: Int?
    }
}

struct GeminiResponse: Codable {
    let candidates: [GeminiCandidate]?
    let error: GeminiError?

    struct GeminiCandidate: Codable {
        let content: GeminiContent
        let finishReason: String?
    }

    struct GeminiContent: Codable {
        let parts: [GeminiPart]
        let role: String
    }

    struct GeminiPart: Codable {
        let text: String
    }

    struct GeminiError: Codable {
        let message: String
        let code: Int?
    }
}
