//
//  UserProgressTests.swift
//  StatEase-UIKitTests
//
//  Created by Claude Code
//

import XCTest
@testable import StatEase_UIKit

final class UserProgressTests: XCTestCase {

    let testLessonId = "test_lesson_12345"

    override func setUp() {
        super.setUp()
        // テスト前にテストデータをクリア
        UserProgress.shared.resetLessonCompletion(lessonId: testLessonId)
        UserProgress.shared.resetQuizCompletion(lessonId: testLessonId)
    }

    override func tearDown() {
        // テスト後にクリーンアップ
        UserProgress.shared.resetLessonCompletion(lessonId: testLessonId)
        UserProgress.shared.resetQuizCompletion(lessonId: testLessonId)
        super.tearDown()
    }

    // MARK: - Lesson Completion Tests

    func testMarkLessonCompleted() {
        // 初期状態では未完了
        XCTAssertFalse(UserProgress.shared.isLessonCompleted(lessonId: testLessonId))

        // 完了マークを付ける
        UserProgress.shared.markLessonCompleted(lessonId: testLessonId)

        // 完了状態になっている
        XCTAssertTrue(UserProgress.shared.isLessonCompleted(lessonId: testLessonId))
    }

    func testResetLessonCompletion() {
        // 完了マークを付ける
        UserProgress.shared.markLessonCompleted(lessonId: testLessonId)
        XCTAssertTrue(UserProgress.shared.isLessonCompleted(lessonId: testLessonId))

        // リセット
        UserProgress.shared.resetLessonCompletion(lessonId: testLessonId)

        // 未完了状態に戻る
        XCTAssertFalse(UserProgress.shared.isLessonCompleted(lessonId: testLessonId))
    }

    // MARK: - Quiz Completion Tests

    func testMarkQuizCompleted() {
        // 初期状態では未完了
        XCTAssertFalse(UserProgress.shared.isQuizCompleted(lessonId: testLessonId))

        // 完了マークを付ける
        UserProgress.shared.markQuizCompleted(lessonId: testLessonId)

        // 完了状態になっている
        XCTAssertTrue(UserProgress.shared.isQuizCompleted(lessonId: testLessonId))
    }

    func testResetQuizCompletion() {
        // 完了マークを付ける
        UserProgress.shared.markQuizCompleted(lessonId: testLessonId)
        XCTAssertTrue(UserProgress.shared.isQuizCompleted(lessonId: testLessonId))

        // リセット
        UserProgress.shared.resetQuizCompletion(lessonId: testLessonId)

        // 未完了状態に戻る
        XCTAssertFalse(UserProgress.shared.isQuizCompleted(lessonId: testLessonId))
    }

    // MARK: - Multiple Lessons Tests

    func testMultipleLessonsIndependence() {
        let lesson1 = "lesson_1"
        let lesson2 = "lesson_2"

        // lesson1を完了
        UserProgress.shared.markLessonCompleted(lessonId: lesson1)

        // lesson1は完了、lesson2は未完了
        XCTAssertTrue(UserProgress.shared.isLessonCompleted(lessonId: lesson1))
        XCTAssertFalse(UserProgress.shared.isLessonCompleted(lessonId: lesson2))

        // クリーンアップ
        UserProgress.shared.resetLessonCompletion(lessonId: lesson1)
        UserProgress.shared.resetLessonCompletion(lessonId: lesson2)
    }

    // MARK: - Reset All Tests

    func testResetAllProgress() {
        let lesson1 = "lesson_reset_1"
        let lesson2 = "lesson_reset_2"

        // 複数のレッスンとクイズを完了状態にする
        UserProgress.shared.markLessonCompleted(lessonId: lesson1)
        UserProgress.shared.markLessonCompleted(lessonId: lesson2)
        UserProgress.shared.markQuizCompleted(lessonId: lesson1)

        // 全てリセット
        UserProgress.shared.resetAllProgress()

        // 全て未完了になっている
        XCTAssertFalse(UserProgress.shared.isLessonCompleted(lessonId: lesson1))
        XCTAssertFalse(UserProgress.shared.isLessonCompleted(lessonId: lesson2))
        XCTAssertFalse(UserProgress.shared.isQuizCompleted(lessonId: lesson1))
    }
}
