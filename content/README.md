# StatEase UIKit コンテンツアセット

Codex CLI担当が作成するコンテンツファイル群です。Week1〜Week2の成果物として以下を含みます。

## ディレクトリ構造

```
content/
├── lessons/          # JSONレッスンおよびクイズデータ
└── media/
    ├── week01/       # レッスン1〜3の静止図リスト（READMEのみ）
    └── week02/       # レッスン4〜6の静止図リスト（READMEのみ）
```

## ファイル一覧

| ファイル | 概要 |
|----------|------|
| `lessons/sample_lesson.json` | JSONフォーマットの雛形。Claude Code側のデータモデル実装とすり合わせに使用。 |
| `lessons/mean_basic.json` | レッスン1（平均）の本番原稿。6ステップ構成。 |
| `lessons/variance_basic.json` | レッスン2（分散）の本番原稿。6ステップ構成。 |
| `lessons/std_deviation_basic.json` | レッスン3（標準偏差）の本番原稿。6ステップ構成。 |
| `lessons/central_tendency_features.json` | レッスン4（代表値の使い分け）の本番原稿。6ステップ構成。 |
| `lessons/histogram_basics.json` | レッスン5（ヒストグラム）の本番原稿。6ステップ構成。 |
| `lessons/weighted_mean.json` | レッスン6（重み付き平均）の本番原稿。6ステップ構成。 |
| `lessons/chapter1_quiz.json` | レッスン1〜3の復習クイズ（4択×5問）。 |
| `media/week01/README.md` | レッスン1〜3の静止図ファイル名と配置場所をまとめたリスト。PNG本体はデザインドライブに保管。 |
| `media/week02/README.md` | レッスン4〜6の静止図ファイル名と配置場所をまとめたリスト。PNG本体はデザインドライブに保管。 |

## 執筆ポリシー

- 文体は「やさしい結城浩」風の柔らかい語り口を意識しています。
- 数式はインラインでLaTeX記法を記述しています。UIKit表示時は数式描画ライブラリでのレンダリングを想定しています。
- `checkpoint`は学習者が立ち止まって考えられる問いを簡潔に提示しています。
- 画像ファイルはPull Request制約によりリポジトリ外（デザインドライブ）で管理し、このフォルダのREADMEから取得先を参照できます。

このディレクトリは今後のレッスン追加やアニメーション書き出しのベースとして利用してください。
