# Lesson JSON Format v1.0

This document formalizes the lesson JSON structure consumed by the StatEase UIKit prototype. It is aligned with the data models scheduled for Week 1 (Lesson, Step, Quiz, UserProgress).

## Top-level structure

```jsonc
{
  "id": "lesson_mean_basic",
  "title": "算術平均の基礎",
  "subtitle": "平均値を感覚的に理解する",
  "estimated_minutes": 15,
  "topic": "descriptive_statistics",
  "summary": "Lesson overview shown in the course catalog.",
  "learning_objectives": ["Understand the definition of arithmetic mean"],
  "prerequisites": ["numeracy_basics"],
  "steps": [/* Step objects */],
  "resources": {
    "key_terms": ["mean", "data set"],
    "external_links": [
      {
        "title": "参考文献の例",
        "url": "https://example.com/reference"
      }
    ]
  }
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | string | ✅ | Stable identifier used by the app and analytics. Use `lesson_<topic>_<level>`. |
| `title` | string | ✅ | Primary lesson name displayed in lists. |
| `subtitle` | string | ✅ | One-line descriptive subtitle. |
| `estimated_minutes` | number | ✅ | Target completion time in minutes. |
| `topic` | string | ✅ | Taxonomy key for grouping. |
| `summary` | string | ✅ | Short overview used in previews. Supports Markdown. |
| `learning_objectives` | string[] | ✅ | Bullet-friendly sentences (2〜4 items). |
| `prerequisites` | string[] | ✅ (can be empty) | Lesson IDs or curriculum tags. |
| `steps` | Step[] | ✅ | Ordered instructional steps. |
| `resources.key_terms` | string[] | ✅ | Terms highlighted in glossary callouts. |
| `resources.external_links` | {title,url}[] | optional | Supplemental reading. |

## Step object

```jsonc
{
  "id": "lesson_mean_basic_step01",
  "order": 1,
  "type": "text",
  "title": "データの中央を探そう",
  "body": "文言（Markdown対応）。",
  "media": {
    "type": "image",
    "asset_name": "mean_basic_fig01.png",
    "caption": "平均値のイメージ"
  },
  "checkpoint": {
    "prompt": "平均値を求める公式は？",
    "expected_answer": "全データの合計を件数で割る"
  }
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | string | ✅ | Unique within the lesson. Recommended format `<lesson_id>_stepNN`. |
| `order` | integer | ✅ | 1-based ordering value. |
| `type` | string | ✅ | `text`, `image`, `video`, or `interactive`. Determines rendering cell. |
| `title` | string | ✅ | Step heading shown in detail screen. |
| `body` | string | ✅ | Main explanation (Markdown). Required even if `media` is present. |
| `media` | object – optional | Provides associated asset metadata. Use `type` (`image`, `video`) and `asset_name` (bundle filename). |
| `checkpoint` | object – optional | Lightweight comprehension check. Include `prompt` and `expected_answer`. |

> **Note:** UIKit cells should gracefully ignore `media` and `checkpoint` when absent. This ensures text-only steps remain valid.

## Quiz data structure

The `chapter1_quiz.json` file follows this schema:

```jsonc
{
  "id": "chapter1_quiz",
  "title": "Chapter 1 復習クイズ",
  "description": "レッスン1〜3の理解度を測ろう",
  "shuffle": true,
  "time_limit_seconds": null,
  "questions": [
    {
      "id": "chapter1_q01",
      "order": 1,
      "prompt": "問題文（Markdown対応）",
      "choices": [
        {"id": "a", "text": "選択肢A", "is_correct": false},
        {"id": "b", "text": "選択肢B", "is_correct": true}
      ],
      "explanation": "正答の解説",
      "tags": ["mean"]
    }
  ]
}
```

Quiz rules:

1. `choices` must contain 4 options for MVP lessons with exactly one `is_correct: true`.
2. `explanation` should reference the related lesson step for continuity.
3. `tags` use lesson IDs or concepts (e.g., `"variance"`).

## Sample assets

- Place lesson JSON under `content/lessons/`.
- Store PNG figure **filenames** under `content/media/week01/README.md`; actual
  binaries live in the shared design drive to keep PRs text-only (2枚/lesson).
- Manim outputs will later live in `content/media/animations/`.

This format ensures Claude Code can parse lessons into strongly typed Swift models while Codex CLI focuses on authoring rich instructional content.
