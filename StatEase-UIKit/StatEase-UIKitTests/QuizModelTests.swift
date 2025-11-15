//
//  QuizModelTests.swift
//  StatEase-UIKitTests
//
//  Created by Claude Code
//

import XCTest
@testable import StatEase_UIKit

final class QuizModelTests: XCTestCase {

    // MARK: - Quiz Decoding Tests

    func testQuizDecoding() throws {
        let jsonData = """
        {
          "id": "mean_quiz_1",
          "lessonId": "mean_basic",
          "question": "3,4,5 の平均はどれですか？",
          "options": [
            "3",
            "3.5",
            "4",
            "4.5"
          ],
          "answerIndex": 2,
          "explanation": "3+4+5=12 を 3 で割るので 4 になります。"
        }
        """.data(using: .utf8)!

        let quiz = try JSONDecoder().decode(Quiz.self, from: jsonData)

        XCTAssertEqual(quiz.id, "mean_quiz_1")
        XCTAssertEqual(quiz.lessonId, "mean_basic")
        XCTAssertEqual(quiz.question, "3,4,5 の平均はどれですか？")
        XCTAssertEqual(quiz.options.count, 4)
        XCTAssertEqual(quiz.options[0], "3")
        XCTAssertEqual(quiz.options[1], "3.5")
        XCTAssertEqual(quiz.options[2], "4")
        XCTAssertEqual(quiz.options[3], "4.5")
        XCTAssertEqual(quiz.answerIndex, 2)
        XCTAssertEqual(quiz.explanation, "3+4+5=12 を 3 で割るので 4 になります。")
    }

    // MARK: - isCorrect Tests

    func testIsCorrectReturnsTrue() throws {
        let quiz = Quiz(
            id: "test_quiz",
            lessonId: "test_lesson",
            question: "テスト問題",
            options: ["A", "B", "C", "D"],
            answerIndex: 2,
            explanation: "解説"
        )

        XCTAssertTrue(quiz.isCorrect(selectedIndex: 2))
    }

    func testIsCorrectReturnsFalse() throws {
        let quiz = Quiz(
            id: "test_quiz",
            lessonId: "test_lesson",
            question: "テスト問題",
            options: ["A", "B", "C", "D"],
            answerIndex: 2,
            explanation: "解説"
        )

        XCTAssertFalse(quiz.isCorrect(selectedIndex: 0))
        XCTAssertFalse(quiz.isCorrect(selectedIndex: 1))
        XCTAssertFalse(quiz.isCorrect(selectedIndex: 3))
    }
}
