# StatEase-UIKit 開発スケジュール v1.0

**作成日**: 2025-11-15
**対象**: MVP（記述統計9レッスン + 基本機能）
**体制**: 2人並行開発

---

## 👥 役割分担

### Claude Code: アプリケーション開発担当
- データモデルの実装
- Repository層の実装
- ViewController実装
- API通信の実装
- データ永続化（UserDefaults, Keychain）
- UI実装（TableView, Cell, レイアウト）
- テスト・デバッグ

### Codex CLI: コンテンツ・デザイン担当
- レッスンテキストの執筆
- 確認問題の作成
- 静止図の作成
- Manimアニメーションの作成
- JSONデータの作成

---

## 📅 全体スケジュール（約4週間）

| Week | Claude Code | Codex CLI |
|------|------------|-----------|
| Week 1 | Phase 1: 基盤構築（モデル・Repository） | Phase 1: サンプルコンテンツ + 本番1〜3 |
| Week 2 | Phase 2: 画面実装（一覧・詳細・クイズ） | Phase 2: レッスン4〜6 + 静止図前半 |
| Week 3 | Phase 3: AI機能・設定画面 | Phase 3: レッスン7〜9 + 静止図後半 |
| Week 4 | Phase 4: 統合・UI調整・テスト | Phase 4: アニメーション作成・調整 |

---

## Week 1: 基盤構築（5〜7日）

### Claude Code: データ・インフラ層
**期間**: 7日
**ステータス**: ✅ 完了

- [x] **Day 1-2: データモデル**
  - `Lesson.swift`, `Step.swift`, `StepType.swift`
  - `Quiz.swift`
  - `UserProgress.swift`
  - ユニットテスト作成

- [x] **Day 3-4: Repository層**
  - `LessonRepository.swift` - JSON読み込み
  - `QuizRepository.swift`
  - Bundle からのファイル読み込み処理
  - エラーハンドリング

- [x] **Day 5: ストレージ層**
  - `UserDefaultsStore.swift` - 進捗管理
  - `KeychainStore.swift` - APIキー保存
  - テスト実装

- [x] **Day 6-7: レッスン一覧画面の実装**
  - `LessonListViewController.swift` 作成
  - `LessonListCell.swift` 作成
  - UITableView セットアップ
  - Repository連携

**成果物**:
- ✅ 動作するRepository
- ✅ レッスン一覧画面（基本版）

---

### Codex CLI: サンプルコンテンツ + 本番開始
**期間**: 7日

- [x] **Day 1: JSONフォーマット確認**
  - Claude Codeが定義したデータ形式を確認
  - サンプルJSON作成（`content/lessons/sample_lesson.json`）

- [x] **Day 2-3: レッスン1（平均）完成版**
  - `mean_basic.json` 執筆
  - やさしい結城浩風の文体で
  - 6ステップ構成 + チェックポイント

- [x] **Day 4: レッスン2（分散）**
  - `variance_basic.json` 執筆

- [x] **Day 5: レッスン3（標準偏差）**
  - `std_deviation_basic.json` 執筆

- [x] **Day 6: 静止図（レッスン1〜3）**
  - 各レッスン2枚（計6枚）のPNGをデザインドライブ `StatEase/UIKit/Week01` へアップロード
  - リポジトリには `content/media/week01/README.md` でファイル名と配置先を記載

- [x] **Day 7: 確認問題**
  - `chapter1_quiz.json` 作成
  - 4択問題 × 5問

**成果物**:
- レッスン1〜3のJSON
- 静止図6枚
- 確認問題5問

---

## Week 2: 画面実装（7日）

### Claude Code: 全画面の実装
**期間**: 7日

- [ ] **Day 1-2: レッスン詳細画面**
  - `LessonDetailViewController.swift` 完成
  - `StepTextCell.swift` - テキスト表示
  - `StepImageCell.swift` - 画像表示
  - `StepVideoCell.swift` - AVPlayerLayer実装
  - タップ再生機能
  - スクロール完了検知

- [ ] **Day 3-4: 確認問題画面**
  - `QuizViewController.swift` 作成
  - 問題文・選択肢のレイアウト
  - 正誤判定ロジック
  - 解説表示
  - 複数問題の管理

- [ ] **Day 5-6: レッスン一覧のブラッシュアップ**
  - 完了状態の表示改善
  - セルのデザイン調整
  - 画面遷移の改善

- [ ] **Day 7: テスト・バグ修正**
  - 動作確認
  - クラッシュ修正
  - データ連携のテスト

**成果物**:
- レッスン一覧・詳細・クイズ画面の完成
- 基本的な学習フローが動作

---

### Codex CLI: コンテンツ作成（中盤）
**期間**: 7日

- [x] **Day 1-2: レッスン4〜5**
  - 代表値の特徴
  - ヒストグラム
  - JSON執筆

- [x] **Day 3-4: レッスン6**
  - 算術平均と加重平均
  - JSON執筆

- [x] **Day 5-7: 静止図作成（レッスン4〜6）**
  - 各レッスン2〜3枚
  - グラフ・概念図
  - PNG書き出し

**成果物**:
- レッスン4〜6のJSON
- 静止図6〜9枚

---

## Week 3: AI機能・設定画面（7日）

### Claude Code: AI機能の実装
**期間**: 7日

- [ ] **Day 1-2: OpenAI API連携**
  - `OpenAIClient.swift` 作成
  - ChatCompletion APIの実装
  - エラーハンドリング（ネットワーク、APIキーエラー）
  - タイムアウト処理

- [ ] **Day 3-4: 設定画面**
  - `SettingsViewController.swift` 作成
  - APIキー入力UI
  - 保存/削除ボタン
  - KeychainStore連携
  - バリデーション

- [ ] **Day 5-6: AI質問画面**
  - `ChatViewController.swift` 作成
  - チャットログのUITableView
  - ユーザー/AIメッセージセル
  - 下部入力ビュー
  - キーボード対応

- [ ] **Day 7: プロンプト調整**
  - System promptの設計
  - レッスンコンテキストの生成
  - 300字制限の実装
  - テスト

**成果物**:
- 動作するAI質問機能
- 設定画面

---

### Codex CLI: コンテンツ作成（後半）
**期間**: 7日

- [x] **Day 1-2: レッスン7〜8**
  - 変動係数
  - データのばらつきの直感
  - JSON執筆（`content/lessons/coefficient_of_variation.json`, `content/lessons/variability_intuition.json`）

- [x] **Day 3: レッスン9（まとめ）**
  - 1章まとめ
  - JSON執筆（`content/lessons/chapter1_summary.json`）

- [x] **Day 4-5: 静止図作成（レッスン7〜9）**
  - 各レッスン2枚
  - 計6枚（`content/media/week03/README.md` に配置一覧を追加）

- [x] **Day 6-7: Manim環境構築・テスト**
  - Manimのインストール
  - サンプルアニメーション作成（`content/media/animations/week03/sample_scene.py`）
  - 書き出しテスト手順を `docs/v1.0/content/manim_setup_checklist.md` に整理

**成果物**:
- レッスン7〜9のJSON（全9レッスン完成！）
- 静止図6枚
- Manim環境の準備完了

---

## Week 4: 統合・仕上げ（7日）

### Claude Code: 統合・UI調整・テスト
**期間**: 7日

- [ ] **Day 1-2: 統合テスト**
  - 全画面の連携確認
  - データフローのテスト
  - 進捗保存の確認
  - AI質問機能の実地テスト

- [ ] **Day 3-4: UI/UX調整**
  - フォント・色・余白の統一
  - ナビゲーションバーの調整
  - エラー表示の改善
  - ローディング表示

- [ ] **Day 5: バグ修正**
  - クラッシュ修正
  - データ読み込みエラー対応
  - 境界値テスト

- [ ] **Day 6-7: 最終テスト・リリース準備**
  - 実機テスト
  - パフォーマンス確認
  - メモリリーク確認
  - 総合テスト

**成果物**:
- 安定動作する完成版アプリ

---

### Codex CLI: アニメーション作成
**期間**: 7日

- [x] **Day 1-3: 優先レッスンのアニメ**
  - レッスン1（平均）: 2本
  - レッスン2（分散）: 2本
  - レッスン3（標準偏差）: 2本
  - 計6本（`content/media/animations/week04/` にスクリプトを追加）

- [ ] **Day 4-5: 追加アニメ（可能な範囲で）**
  - レッスン4〜6のアニメ
  - 各1〜2本

- [ ] **Day 6-7: 調整・書き出し**
  - アニメの品質チェック
  - mp4書き出し（READMEにレンダリングコマンドを追記）
  - ファイルサイズ最適化
  - Claude Codeと連携してアプリへの組み込み確認

**成果物**:
- 最低6本のアニメーション
- 可能であれば追加3〜6本
- `content/media/animations/week04/README.md` にレンダリング手順を記載

---

## 🔄 並行作業のポイント

### Week 1の依存関係
```
Claude Code (Day 1: モデル定義) → Codex CLI (Day 1: JSONフォーマット確認)
Claude Code (Day 1-5: インフラ) → Codex CLI (独立してコンテンツ作成可能)
```

### Week 2の並行作業
- Claude Code: 画面実装（Codex CLIのコンテンツを使用）
- Codex CLI: 独立してコンテンツ作成
- **同期不要** - それぞれ独立作業可能

### Week 3の並行作業
- Claude Code: AI機能実装
- Codex CLI: 残りコンテンツ + Manim準備
- **同期不要** - それぞれ独立作業可能

### Week 4の統合
- Claude Code: アプリ本体の完成度を上げる
- Codex CLI: アニメーション作成
- **最終日**: 総合テスト・動作確認

---

## 📊 進捗管理

### 毎日の同期（推奨）
- 15分のスタンドアップ
  - 昨日やったこと
  - 今日やること
  - ブロッカー

### 週次マイルストーン
- Week 1終了: 基盤完成、サンプル動作
- Week 2終了: 全機能実装、レッスン5本
- Week 3終了: MVP完成

---

## ⚠️ リスクと対策

### リスク1: Claude Code の遅延が全体に影響
**対策**:
- Week 1のモデル定義は最優先
- Day 1終了時にデータフォーマットを確定
- Codex CLIはDay 1からコンテンツ作成を開始できる

### リスク2: コンテンツ量が多すぎる
**対策**:
- Week 2で5レッスン、Week 3で4レッスンの分割
- アニメは最低6本（全部作れなくてもOK）
- 静止図で代替可能

### リスク3: AI機能の調整に時間がかかる
**対策**:
- Week 3で時間を確保
- 最悪、AI機能なしでもMVPとして成立する
- プロンプト調整は後からでも可能

---

## 🎯 最低限のゴール（3週間後）

- ✅ 全9レッスンのテキスト・図が揃っている
- ✅ 最低3本のアニメーション
- ✅ 確認問題が1章分ある
- ✅ AI質問機能が動作する
- ✅ 進捗が保存される
- ✅ クラッシュしない

---

## 次のステップ

1. **開発開始前の準備**
   - このスケジュールの確認
   - データフォーマットのすり合わせ

2. **Claude Code が Week 1 Day 1 を開始**
   - データモデルの実装
   - JSON形式の確定・共有

3. **Codex CLI も Day 1 から開始**
   - JSONフォーマット確認後、コンテンツ執筆開始

4. **週次チェックポイント（推奨）**
   - 進捗確認
   - 問題の共有
   - 次週の調整

---

以上がClaude Code（開発）とCodex CLI（コンテンツ）による開発スケジュールです。
並行作業により、従来の4〜6週間が **約4週間** に短縮されます。

## 🤖 ツールの使い分け

### Claude Code の強み
- コード実装の自動化
- ファイル操作・編集
- デバッグ・テスト実行
- Git操作

### Codex CLI の強み
- 自然言語での文章作成
- JSONデータの生成
- 図やアニメーションの説明・スクリプト生成
- コンテンツの一貫性維持

---

## 🎯 統合フロー（Week 4）

Week 4では、Claude CodeとCodex CLIの成果物を統合して完成させます。

### 統合のステップ

1. **コンテンツの配置**
   - Codex CLIが作成したJSONファイルを `Lessons/` に配置
   - 静止図を `Assets/Images/` に配置
   - 動画ファイルを `Assets/Videos/` に配置

2. **動作確認**
   - Claude CodeがアプリからJSONを読み込み
   - 画像・動画が正しく表示されるか確認

3. **最終調整**
   - レイアウトのズレ修正
   - 文字サイズ・余白の調整
   - コンテンツとUIの整合性確認

4. **完成**
   - 全レッスンが動作
   - AI質問機能が動作
   - 進捗保存が動作
   - **アプリとして完成！**

### 統合のイメージ
```
Codex CLI の成果物           Claude Code の成果物
├── Lessons/*.json     ─┐
├── Images/*.png        ├─→ Bundle に配置 → アプリで読み込み
└── Videos/*.mp4       ─┘
                              ├── Models/
                              ├── ViewControllers/
                              ├── Repositories/
                              └── 完成したアプリ
```

**Week 4の最終日には、すべてががっちゃんこして完成したアプリができあがります！**
