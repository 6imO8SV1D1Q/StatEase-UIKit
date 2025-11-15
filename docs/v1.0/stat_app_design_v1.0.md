# 統計検定2級 初学者向け学習アプリ  
基本設計書 v1.0

---

## 0. この文書について

本書は「統計検定2級 初学者向け学習アプリ」の **基本設計** をまとめたものである。  
要件定義書 v1.0 に基づき、実装に着手できるレベルの構造・画面・データ・処理の設計を示す。

- 対象プラットフォーム：iOS（iPhone）
- UIフレームワーク：UIKit
- 開発言語：Swift
- アーキテクチャ方針：**原則 MVC。ただし記述量や画面の複雑さが増えた場合、MVVM などの適用を検討する。**

---

## 1. システム全体構成

### 1.1 概要

本アプリは、以下のレイヤで構成される：

- **Presentation（UI）層**
  - UIKit による View / ViewController
- **Domain / Model 層**
  - Lesson / Step / Quiz / UserProgress などのデータモデル
- **Infrastructure 層**
  - JSON ローダー、動画管理、AI クライアント、永続化（UserDefaults / Keychain）など

### 1.2 簡易構成図（概念）

```text
App
├── Presentation（MVCベース）
│   ├── ViewController（画面単位）
│   ├── View（UITableViewCell, UIView など）
│   └── Storyboard / XIB（必要に応じて）
│
├── Model
│   ├── Lesson / Step / Quiz
│   ├── UserProgress
│   └── APIKey
│
└── Infrastructure
    ├── LessonRepository（JSON 読み込み）
    ├── QuizRepository
    ├── VideoManager
    ├── OpenAIClient
    ├── UserDefaultsStore
    └── KeychainStore
```

---

## 2. アーキテクチャ方針

### 2.1 原則：MVC

基本方針として、各画面は **UIKit の標準的な MVC** で設計する。

- **Model**
  - Lesson, Step, Quiz, UserProgress, APIKey など
- **View**
  - Storyboard / XIB / コードで定義された UIView, UITableViewCell, UICollectionViewCell
- **Controller**
  - LessonListViewController
  - LessonDetailViewController
  - QuizViewController
  - ChatViewController
  - SettingsViewController

Controller は以下を担う：

- Model からデータを取得（Repository 経由）
- View にデータを表示
- ユーザー操作に応じて Model / Infrastructure を呼び出し

### 2.2 必要に応じた MVVM の検討

以下の条件に該当する画面では、将来的に MVVM への移行・部分適用を検討する：

- Controller が肥大化して 500 行以上になりそうな場合
- バインディングすべき状態が多い画面
  - 例：レッスン詳細（ステップが多い）
  - 例：AIチャット画面（メッセージの状態管理）

この場合、以下のように ViewModel を導入する：

```text
LessonDetailViewController
  ├── LessonDetailViewModel
  └── LessonRepository / UserProgressStore
```

しかし **v1.0 の実装では、まず MVC ベースで構築** する。

---

## 3. 画面設計

### 3.1 画面一覧

| 画面ID | 画面名               | 役割                               |
|--------|----------------------|------------------------------------|
| SCR-01 | レッスン一覧         | レッスンのリスト表示、完了状況表示 |
| SCR-02 | レッスン詳細         | ステップ単位の説明・図・アニメ表示 |
| SCR-03 | 確認問題一覧（任意） | 確認問題ユニット一覧              |
| SCR-04 | 確認問題詳細         | 4択問題の出題・解説               |
| SCR-05 | AI質問画面           | レッスン範囲限定のチャット         |
| SCR-06 | 設定画面             | APIキー登録・削除                 |

※MVPでは SCR-03 は省略し、レッスンから直接 SCR-04 に遷移してもよい。

---

### 3.2 画面遷移（MVP）

```text
[SCR-01 レッスン一覧]
        |
        v
[SCR-02 レッスン詳細] ----> [SCR-05 AI質問画面]
        |
        v
[SCR-04 確認問題詳細]
        |
        v
[完了 → SCR-02 に戻る]
```

---

### 3.3 レッスン一覧画面（SCR-01）

**役割**

- レッスンのタイトル一覧を表示
- 所要時間（目安）を表示
- 完了済みレッスンにチェックマークを表示

**主要コンポーネント**

- `UIViewController` : `LessonListViewController`
- `UITableView` / `UICollectionView`（List構造）
- セル：`LessonListCell`
  - タイトルラベル
  - 所要時間ラベル
  - 完了アイコン（チェックマーク）

**動作**

- 起動時に LessonRepository からレッスン一覧を読み込む
- UserDefaultsStore から完了情報を読み込み、セルに反映
- セルタップで `LessonDetailViewController` へ遷移

---

### 3.4 レッスン詳細画面（SCR-02）

**役割**

- 1レッスン分のステップ（テキスト・静止図・動画）を縦に並べて表示
- 下部に「AIに質問する」ボタンを表示

**主要コンポーネント**

- `UIViewController` : `LessonDetailViewController`
- `UITableView` or `UIScrollView + UIStackView`
- `StepTextCell`
- `StepImageCell`
- `StepVideoCell`
- 下部ボタン：`UIButton`（「質問してみる」）

**動作**

- `lessonId` を受け取り、LessonRepository から該当データを取得
- steps 配列をもとに Cell を生成
- VideoCell では AVPlayerLayer を用いてタップ再生
- 画面を最後まで閲覧したタイミングで「レッスン完了」として UserDefaults に記録（条件は要検討）
- 「質問してみる」ボタンタップで SCR-05 へ遷移（lessonId を引き継ぎ）

---

### 3.5 確認問題詳細画面（SCR-04）

**役割**

- 4択問題を1問ずつ出題
- 回答後に正誤表示＆簡易解説

**主要コンポーネント**

- `UIViewController` : `QuizViewController`
- UILabel：問題文
- UIButton ×4：選択肢
- UILabel：解説（回答後に表示）

**動作**

- QuizRepository から quiz データをロード
- 回答タップ → 正誤判定 → 色変化＋解説表示
- 「次の問題へ」ボタン（複数問ある場合）
- 全問終了後、レッスンに紐づけて「確認問題完了」として扱うかは任意

---

### 3.6 AI質問画面（SCR-05）

**役割**

- レッスンに関する疑問をAIに質問し、短い回答を得る

**主要コンポーネント**

- `UIViewController` : `ChatViewController`
- `UITableView`：チャットログ（ユーザー/AIのメッセージ）
- 下部入力ビュー：
  - `UITextView`
  - 送信ボタン

**動作**

1. `LessonDetailViewController` から `lessonId` を受け取る
2. LessonRepository から該当レッスンのテキストを取得し、コンテキストとして保持
3. ユーザー入力 → OpenAIClient へ送信
4. レスポンスをメッセージとして表示
5. 回答の長さは 300字程度にプロンプトで制御

---

### 3.7 設定画面（SCR-06）

**役割**

- AI用 APIキーの登録・削除

**主要コンポーネント**

- `UIViewController` : `SettingsViewController`
- `UITextField` or `UITextView`（APIキー入力欄）
- 保存ボタン
- 削除ボタン

**動作**

- 保存：KeychainStore に保存
- 削除：KeychainStore から削除
- 有効/無効状態の表示（簡単なラベル）

---

## 4. データ設計

### 4.1 Lesson JSON 形式

```json
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
      "type": "text",
      "content": "値の全体的な位置を知りたいときに使います。"
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
    },
    {
      "type": "text",
      "content": "計算は、すべての値を足して個数で割ります。"
    },
    {
      "type": "text",
      "content": "3,4,5 の場合、(3+4+5)/3 = 4 です。"
    },
    {
      "type": "text",
      "content": "平均は「値を足して個数で割った代表値」です。"
    }
  ]
}
```

---

### 4.2 Step モデル（Swift）

```swift
enum StepType: String, Decodable {
    case text
    case image
    case video
}

struct Step: Decodable {
    let type: StepType
    let content: String?       // type == .text
    let file: String?          // type == .image or .video
    let description: String?   // 任意の説明
}

struct Lesson: Decodable {
    let id: String
    let title: String
    let chapter: String
    let durationMinutes: Int
    let steps: [Step]
}
```

---

### 4.3 Quiz JSON 形式

```json
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
```

---

### 4.4 UserProgress

UserDefaults にて簡易管理する。

- キー例：
  - `"lesson_completed_mean_basic": true`
  - `"quiz_completed_mean_basic": true`

Swift モデルは必須ではないが、ラッパ struct を用意しても良い。

---

## 5. 処理設計

### 5.1 レッスン一覧表示処理

1. アプリ起動時または画面表示時に、`LessonRepository` から全レッスンを取得
2. UserDefaults から完了状態を取得
3. `LessonListViewController` が UITableView/CollectionView に反映

---

### 5.2 レッスン詳細表示処理

1. `lessonId` をもとに `LessonRepository` から Lesson を取得
2. `steps` を TableView のデータソースに設定
3. `cellForRowAt` で type に応じて Cell を切り替える
4. 動画セルではタップ時に AVPlayerLayer で再生
5. 必要であれば、最後までスクロールされたタイミングで `UserDefaults` に完了を記録

---

### 5.3 確認問題処理

1. `lessonId` に紐づく Quiz セットを `QuizRepository` から取得
2. 問題１問目を表示
3. 回答タップ → 正誤判定 → 結果表示 → 解説表示
4. 全問終了時に `quiz_completed_\(lessonId)` を true に設定

---

### 5.4 AI質問処理

1. `ChatViewController` が `lessonId` を受け取る
2. `LessonRepository` から該当 Lesson を取得し、テキスト部分を連結してコンテキストとする
3. ユーザー入力を取得
4. OpenAIClient に以下の情報でリクエスト：
   - コンテキスト（レッスンテキスト）
   - 質問文
   - 「300字以内」「比喩なし」「やさしい日本語」の制約を含んだ system prompt
5. レスポンスを受信し、チャット画面に表示

---

## 6. インフラ設計

### 6.1 LessonRepository

- `Lessons/*.json` を読み込む
- キャッシュはメモリ上で簡易に行う

```swift
protocol LessonRepositoryProtocol {
    func fetchAllLessons() -> [Lesson]
    func fetchLesson(id: String) -> Lesson?
}
```

### 6.2 QuizRepository

同様に `Quizzes/*.json` から読み込む。

### 6.3 OpenAIClient

- APIキーは Keychain から取得
- ChatCompletion エンドポイントに POST
- タイムアウトやエラー時はユーザーに再試行を促す

---

## 7. エラー・例外処理方針

- JSON 読み込み失敗：デバッグ用途のアラート、リリースでは簡易エラー画面
- APIキー未設定：AI質問画面に遷移した際に設定画面への導線を表示
- ネットワークエラー：メッセージをチャット内に表示（「ネットワークエラーが発生しました」など）

---

## 8. パフォーマンス・オフライン

- レッスンデータ・画像・動画はアプリ内同梱 → オフライン利用可能
- AI質問のみオンライン必須
- 動画は短尺のためメモリ負荷は限定的だが、スクロールで再利用されるよう Cell 設計に注意

---

## 9. 今後の拡張に向けた設計上の余地

- MVC→MVVMへの移行余地（特に LessonDetail / Chat）
- 章をまたぐ進捗バーやストリークの追加
- 弱点管理（間違えた問題や質問頻度の集計）
- iPad 対応・横画面対応
- Web 版・他プラットフォームへの展開

---

以上が、本アプリの **基本設計書 v1.0** である。
