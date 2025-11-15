//
//  LessonRepository.swift
//  StatEase-UIKit
//
//  Created by Claude Code
//

import Foundation

enum RepositoryError: Error {
    case fileNotFound
    case decodingError(Error)
    case invalidData
}

/// レッスンデータを管理するRepository
class LessonRepository {
    static let shared = LessonRepository()

    private init() {}

    /// すべてのレッスンを取得
    func fetchAllLessons() -> Result<[Lesson], RepositoryError> {
        // まずBundleからJSONファイルを探す
        guard let url = Bundle.main.url(forResource: "lessons", withExtension: "json") else {
            // サンプルデータを返す
            return .success(createSampleLessons())
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let lessons = try decoder.decode([Lesson].self, from: data)
            return .success(lessons)
        } catch {
            return .failure(.decodingError(error))
        }
    }

    /// 特定のレッスンを取得
    func fetchLesson(by id: String) -> Result<Lesson, RepositoryError> {
        let result = fetchAllLessons()
        switch result {
        case .success(let lessons):
            if let lesson = lessons.first(where: { $0.id == id }) {
                return .success(lesson)
            } else {
                return .failure(.fileNotFound)
            }
        case .failure(let error):
            return .failure(error)
        }
    }

    /// サンプルレッスンを作成
    private func createSampleLessons() -> [Lesson] {
        let step1 = Step(
            id: "step1",
            type: .text,
            title: "平均とは？",
            content: "平均は、データの代表値を表す統計量です。すべてのデータを足し合わせて、データの個数で割ることで求められます。",
            imageName: nil,
            videoName: nil,
            order: 1
        )

        let step2 = Step(
            id: "step2",
            type: .text,
            title: "平均の計算方法",
            content: "例えば、5人のテストの点数が 80, 75, 90, 85, 70 だった場合、\n平均 = (80 + 75 + 90 + 85 + 70) / 5 = 80 点となります。",
            imageName: nil,
            videoName: nil,
            order: 2
        )

        let lesson1 = Lesson(
            id: "lesson1",
            title: "平均（基礎）",
            description: "データの代表値である平均について学びます",
            thumbnailName: nil,
            difficulty: "初級",
            estimatedMinutes: 10,
            steps: [step1, step2],
            quizId: "quiz1"
        )

        return [lesson1]
    }
}
