//
//  LessonModelTests.swift
//  StatEase-UIKitTests
//
//  Created by Claude Code
//

import XCTest
@testable import StatEase_UIKit

final class LessonModelTests: XCTestCase {

    // MARK: - StepType Tests

    func testStepTypeDecoding() throws {
        let jsonData = """
        {
            "type": "text",
            "content": "これは平均の説明です。"
        }
        """.data(using: .utf8)!

        let step = try JSONDecoder().decode(Step.self, from: jsonData)
        XCTAssertEqual(step.type, .text)
        XCTAssertEqual(step.content, "これは平均の説明です。")
    }

    // MARK: - Step Tests

    func testStepTextDecoding() throws {
        let jsonData = """
        {
            "type": "text",
            "content": "平均は、複数の値をひとつの代表値で表すための量です。"
        }
        """.data(using: .utf8)!

        let step = try JSONDecoder().decode(Step.self, from: jsonData)
        XCTAssertEqual(step.type, .text)
        XCTAssertEqual(step.content, "平均は、複数の値をひとつの代表値で表すための量です。")
        XCTAssertNil(step.file)
    }

    func testStepImageDecoding() throws {
        let jsonData = """
        {
            "type": "image",
            "file": "mean_step1.png",
            "description": "3,4,5 を数直線に並べた図"
        }
        """.data(using: .utf8)!

        let step = try JSONDecoder().decode(Step.self, from: jsonData)
        XCTAssertEqual(step.type, .image)
        XCTAssertEqual(step.file, "mean_step1.png")
        XCTAssertEqual(step.description, "3,4,5 を数直線に並べた図")
    }

    func testStepVideoDecoding() throws {
        let jsonData = """
        {
            "type": "video",
            "file": "mean_anim1.mp4",
            "description": "3,4,5 が動いて平均位置が動く様子"
        }
        """.data(using: .utf8)!

        let step = try JSONDecoder().decode(Step.self, from: jsonData)
        XCTAssertEqual(step.type, .video)
        XCTAssertEqual(step.file, "mean_anim1.mp4")
        XCTAssertEqual(step.description, "3,4,5 が動いて平均位置が動く様子")
    }

    // MARK: - Lesson Tests

    func testLessonDecoding() throws {
        let jsonData = """
        {
          "id": "mean_basic",
          "title": "平均とは何か",
          "chapter": "descriptive",
          "durationMinutes": 5,
          "steps": [
            {
              "type": "text",
              "content": "平均は、複数の値をひとつの代表値で表すための量です。"
            },
            {
              "type": "image",
              "file": "mean_step1.png",
              "description": "3,4,5 を数直線に並べた図"
            },
            {
              "type": "video",
              "file": "mean_anim1.mp4",
              "description": "3,4,5 が動いて平均位置が動く様子"
            }
          ]
        }
        """.data(using: .utf8)!

        let lesson = try JSONDecoder().decode(Lesson.self, from: jsonData)

        XCTAssertEqual(lesson.id, "mean_basic")
        XCTAssertEqual(lesson.title, "平均とは何か")
        XCTAssertEqual(lesson.chapter, "descriptive")
        XCTAssertEqual(lesson.durationMinutes, 5)
        XCTAssertEqual(lesson.steps.count, 3)

        // 各ステップの検証
        XCTAssertEqual(lesson.steps[0].type, .text)
        XCTAssertEqual(lesson.steps[1].type, .image)
        XCTAssertEqual(lesson.steps[2].type, .video)
    }
}
