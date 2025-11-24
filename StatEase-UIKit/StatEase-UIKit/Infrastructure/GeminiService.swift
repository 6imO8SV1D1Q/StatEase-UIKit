//
//  GeminiService.swift
//  StatEase-UIKit
//
//  Created by Claude Code
//

import Foundation

enum GeminiError: Error {
    case invalidAPIKey
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
    case apiError(String)
}

protocol AIServiceProtocol {
    func sendMessage(_ message: String, context: String?, completion: @escaping (Result<String, GeminiError>) -> Void)
}

class GeminiService: AIServiceProtocol {

    private let baseURL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent"

    nonisolated private func decodeResponse(_ data: Data) throws -> GeminiResponse {
        let decoder = JSONDecoder()
        return try decoder.decode(GeminiResponse.self, from: data)
    }

    func sendMessage(_ message: String, context: String? = nil, completion: @escaping (Result<String, GeminiError>) -> Void) {

        // APIキーを取得（APIConfiguration から）
        let apiKey = APIConfiguration.geminiAPIKey
        guard !apiKey.isEmpty && apiKey != "YOUR_GEMINI_API_KEY_HERE" else {
            completion(.failure(.invalidAPIKey))
            return
        }

        // URLを作成（クエリパラメータにAPIキーを含める）
        guard var urlComponents = URLComponents(string: baseURL) else {
            completion(.failure(.invalidResponse))
            return
        }
        urlComponents.queryItems = [URLQueryItem(name: "key", value: apiKey)]

        guard let url = urlComponents.url else {
            completion(.failure(.invalidResponse))
            return
        }

        // リクエストを構築
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // メッセージを構築
        var contents: [GeminiRequest.GeminiContent] = []

        // システムメッセージ + ユーザーメッセージを結合
        var fullMessage = ""
        if let context = context {
            fullMessage = """
            あなたは統計学を学ぶ学生を支援する親切なアシスタントです。
            以下は現在ユーザーが学習している記事の内容です：

            \(context)

            この記事の内容に基づいて、ユーザーの質問に丁寧に答えてください。
            可能な限り具体例を交えて、わかりやすく説明してください。

            ユーザーの質問: \(message)
            """
        } else {
            fullMessage = message
        }

        // Gemini形式のコンテンツ
        let content = GeminiRequest.GeminiContent(
            parts: [GeminiRequest.GeminiPart(text: fullMessage)],
            role: "user"
        )
        contents.append(content)

        // リクエストボディ
        let requestBody = GeminiRequest(
            contents: contents,
            generationConfig: GeminiRequest.GeminiGenerationConfig(
                temperature: 0.7,
                maxOutputTokens: 2048
            )
        )

        do {
            request.httpBody = try JSONEncoder().encode(requestBody)
        } catch {
            completion(.failure(.networkError(error)))
            return
        }

        // APIリクエストを送信
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }

            guard let data = data else {
                completion(.failure(.invalidResponse))
                return
            }

            // デバッグ: レスポンスを出力
            if let responseString = String(data: data, encoding: .utf8) {
                print("API Response: \(responseString)")
            }

            // レスポンスをデコード
            let geminiResponse: GeminiResponse
            do {
                geminiResponse = try self.decodeResponse(data)
            } catch {
                print("Decoding error: \(error)")
                completion(.failure(.decodingError(error)))
                return
            }

            // エラーチェック
            if let error = geminiResponse.error {
                completion(.failure(.apiError(error.message)))
                return
            }

            // レスポンステキストを取得
            if let firstCandidate = geminiResponse.candidates?.first,
               let parts = firstCandidate.content.parts,
               let firstPart = parts.first {
                completion(.success(firstPart.text))
            } else {
                print("No parts in response or empty response")
                completion(.failure(.invalidResponse))
            }
        }

        task.resume()
    }
}
