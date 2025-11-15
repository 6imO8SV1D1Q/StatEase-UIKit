//
//  QuizRepository.swift
//  StatEase-UIKit
//
//  Created by Claude Code
//

import Foundation

/// クイズデータを管理するRepository
class QuizRepository {
    static let shared = QuizRepository()

    private init() {}

    /// クイズを取得
    func fetchQuiz(by id: String) -> Result<Quiz, RepositoryError> {
        // まずBundleからJSONファイルを探す
        guard let url = Bundle.main.url(forResource: id, withExtension: "json") else {
            // サンプルデータを返す
            return .success(createSampleQuiz(id: id))
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let quiz = try decoder.decode(Quiz.self, from: data)
            return .success(quiz)
        } catch {
            return .failure(.decodingError(error))
        }
    }

    /// サンプルクイズを作成
    private func createSampleQuiz(id: String) -> Quiz {
        let option1 = QuizOption(id: "opt1", text: "すべてのデータを足して個数で割る", isCorrect: true)
        let option2 = QuizOption(id: "opt2", text: "最大値と最小値を足して2で割る", isCorrect: false)
        let option3 = QuizOption(id: "opt3", text: "データを大きい順に並べて真ん中の値を取る", isCorrect: false)
        let option4 = QuizOption(id: "opt4", text: "最も頻繁に出現する値を取る", isCorrect: false)

        let question1 = QuizQuestion(
            id: "q1",
            question: "平均の正しい求め方はどれですか？",
            options: [option1, option2, option3, option4],
            explanation: "平均は、すべてのデータを足し合わせて、データの個数で割ることで求められます。",
            order: 1
        )

        return Quiz(
            id: id,
            title: "平均の理解度チェック",
            description: "平均について学んだ内容を確認しましょう",
            questions: [question1]
        )
    }
}
