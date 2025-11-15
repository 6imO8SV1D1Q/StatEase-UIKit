//
//  Quiz.swift
//  StatEase-UIKit
//
//  Created by Claude Code
//

import Foundation

/// 確認問題（4択問題）を表すモデル
struct Quiz: Decodable {
    let id: String
    let lessonId: String           // どのレッスンに紐づくか
    let question: String           // 問題文
    let options: [String]          // 選択肢（4つ）
    let answerIndex: Int           // 正解のインデックス（0-3）
    let explanation: String        // 解説

    /// 選択した回答が正解かどうかを判定
    /// - Parameter selectedIndex: 選択した選択肢のインデックス
    /// - Returns: 正解の場合true
    func isCorrect(selectedIndex: Int) -> Bool {
        return selectedIndex == answerIndex
    }
}
