//
//  LessonRepository.swift
//  StatEase-UIKit
//
//  Created by Claude Code
//

import Foundation

/// Repository のエラー型
enum RepositoryError: Error {
    case fileNotFound(String)
    case decodingFailed(Error)
    case invalidData
}

/// LessonRepository のプロトコル
protocol LessonRepositoryProtocol {
    func fetchAllLessons() throws -> [Lesson]
    func fetchLesson(id: String) throws -> Lesson?
}

/// レッスンデータの取得を担当するリポジトリ
class LessonRepository: LessonRepositoryProtocol {

    // MARK: - Properties

    private let bundle: Bundle
    private let lessonsDirectoryName = "Lessons"
    private var cachedLessons: [Lesson]?

    // MARK: - Initialization

    init(bundle: Bundle = .main) {
        self.bundle = bundle
    }

    // MARK: - Public Methods

    /// すべてのレッスンを取得する
    /// - Returns: レッスンの配列
    /// - Throws: RepositoryError
    func fetchAllLessons() throws -> [Lesson] {
        // キャッシュがあればそれを返す
        if let cached = cachedLessons {
            return cached
        }

        var lessons: [Lesson] = []

        // Bundleから Lessons ディレクトリ内の全JSONファイルを取得
        guard let resourcePath = bundle.resourcePath else {
            throw RepositoryError.fileNotFound("Resource path not found")
        }

        let lessonsPath = (resourcePath as NSString).appendingPathComponent(lessonsDirectoryName)
        let fileManager = FileManager.default

        guard fileManager.fileExists(atPath: lessonsPath) else {
            // ディレクトリが存在しない場合は空配列を返す（初期状態）
            return []
        }

        let fileURLs = try fileManager.contentsOfDirectory(
            at: URL(fileURLWithPath: lessonsPath),
            includingPropertiesForKeys: nil
        ).filter { $0.pathExtension == "json" }

        for fileURL in fileURLs {
            do {
                let data = try Data(contentsOf: fileURL)
                let lesson = try JSONDecoder().decode(Lesson.self, from: data)
                lessons.append(lesson)
            } catch {
                print("Warning: Failed to decode lesson from \(fileURL.lastPathComponent): \(error)")
                // 1つのファイルが失敗しても続行する
                continue
            }
        }

        // キャッシュに保存
        cachedLessons = lessons

        return lessons
    }

    /// 指定したIDのレッスンを取得する
    /// - Parameter id: レッスンID
    /// - Returns: レッスン（見つからない場合はnil）
    /// - Throws: RepositoryError
    func fetchLesson(id: String) throws -> Lesson? {
        let allLessons = try fetchAllLessons()
        return allLessons.first { $0.id == id }
    }

    /// キャッシュをクリアする
    func clearCache() {
        cachedLessons = nil
    }

    // MARK: - Private Methods

    /// 指定したファイル名のJSONファイルからレッスンを読み込む
    /// - Parameter fileName: ファイル名（拡張子なし）
    /// - Returns: レッスン
    /// - Throws: RepositoryError
    private func loadLesson(fileName: String) throws -> Lesson {
        guard let url = bundle.url(
            forResource: fileName,
            withExtension: "json",
            subdirectory: lessonsDirectoryName
        ) else {
            throw RepositoryError.fileNotFound("Lesson file not found: \(fileName).json")
        }

        let data = try Data(contentsOf: url)

        do {
            let lesson = try JSONDecoder().decode(Lesson.self, from: data)
            return lesson
        } catch {
            throw RepositoryError.decodingFailed(error)
        }
    }
}
