//
//  QuizRepository.swift
//  StatEase-UIKit
//
//  Created by Claude Code
//

import Foundation

/// QuizRepository のプロトコル
protocol QuizRepositoryProtocol {
    func fetchAllQuizzes() throws -> [Quiz]
    func fetchQuiz(id: String) throws -> Quiz?
}

/// 確認問題データの取得を担当するリポジトリ
class QuizRepository: QuizRepositoryProtocol {

    // MARK: - Properties

    private let bundle: Bundle
    private let quizzesDirectoryName = "content/lessons"
    private var cachedQuizzes: [Quiz]?

    // MARK: - Initialization

    init(bundle: Bundle = .main) {
        self.bundle = bundle
    }

    // MARK: - Public Methods

    /// すべての確認問題を取得する
    /// - Returns: 確認問題の配列
    /// - Throws: RepositoryError
    func fetchAllQuizzes() throws -> [Quiz] {
        // キャッシュがあればそれを返す
        if let cached = cachedQuizzes {
            return cached
        }

        var quizzes: [Quiz] = []

        // Bundleから Quizzes ディレクトリ内の全JSONファイルを取得
        guard let resourcePath = bundle.resourcePath else {
            throw RepositoryError.fileNotFound("Resource path not found")
        }

        let quizzesPath = (resourcePath as NSString).appendingPathComponent(quizzesDirectoryName)
        let fileManager = FileManager.default

        guard fileManager.fileExists(atPath: quizzesPath) else {
            // ディレクトリが存在しない場合は空配列を返す（初期状態）
            return []
        }

        let fileURLs = try fileManager.contentsOfDirectory(
            at: URL(fileURLWithPath: quizzesPath),
            includingPropertiesForKeys: nil
        ).filter { $0.pathExtension == "json" }

        for fileURL in fileURLs {
            do {
                let data = try Data(contentsOf: fileURL)
                let decoder = JSONDecoder()

                // 単一のQuizか配列かを判定
                if let quiz = try? decoder.decode(Quiz.self, from: data) {
                    quizzes.append(quiz)
                } else if let quizArray = try? decoder.decode([Quiz].self, from: data) {
                    quizzes.append(contentsOf: quizArray)
                } else {
                    print("Warning: Failed to decode quiz from \(fileURL.lastPathComponent)")
                }
            } catch {
                print("Warning: Failed to load quiz from \(fileURL.lastPathComponent): \(error)")
                continue
            }
        }

        // キャッシュに保存
        cachedQuizzes = quizzes

        return quizzes
    }

    /// 指定したクイズIDの確認問題を取得する
    /// - Parameter id: クイズID
    /// - Returns: 確認問題（見つからない場合はnil）
    /// - Throws: RepositoryError
    func fetchQuiz(id: String) throws -> Quiz? {
        let allQuizzes = try fetchAllQuizzes()
        return allQuizzes.first { $0.id == id }
    }

    /// キャッシュをクリアする
    func clearCache() {
        cachedQuizzes = nil
    }
}
