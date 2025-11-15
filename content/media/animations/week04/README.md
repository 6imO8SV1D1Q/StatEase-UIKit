# Week 4 Animation Scripts

Week 4 delivers six Manim scenes that cover the priority lessons (1〜3) from Chapter 1.  
Render each scene with Manim's CLI (`-qm` = medium quality, `-qh` = high quality).  The suggested outputs are MP4 files for integration into the iOS app.

## Priority animations (lessons 1〜3)

| Lesson | Script | Scene class | Suggested command |
| --- | --- | --- | --- |
| Lesson 1 (平均) | `lesson1_mean_balance_point.py` | `Lesson1MeanBalancePoint` | `manim content/media/animations/week04/lesson1_mean_balance_point.py Lesson1MeanBalancePoint -qm` |
| Lesson 1 (加重平均) | `lesson1_weighted_mean_example.py` | `Lesson1WeightedMeanExample` | `manim content/media/animations/week04/lesson1_weighted_mean_example.py Lesson1WeightedMeanExample -qm` |
| Lesson 2 (分散の直感) | `lesson2_variance_spread_visual.py` | `Lesson2VarianceSpreadVisual` | `manim content/media/animations/week04/lesson2_variance_spread_visual.py Lesson2VarianceSpreadVisual -qm` |
| Lesson 2 (計算手順) | `lesson2_variance_formula_walkthrough.py` | `Lesson2VarianceFormulaWalkthrough` | `manim content/media/animations/week04/lesson2_variance_formula_walkthrough.py Lesson2VarianceFormulaWalkthrough -qm` |
| Lesson 3 (分散と標準偏差) | `lesson3_stddev_variance_link.py` | `Lesson3StdDevVarianceLink` | `manim content/media/animations/week04/lesson3_stddev_variance_link.py Lesson3StdDevVarianceLink -qm` |
| Lesson 3 (ばらつき比較) | `lesson3_stddev_compare_datasets.py` | `Lesson3StdDevCompareDatasets` | `manim content/media/animations/week04/lesson3_stddev_compare_datasets.py Lesson3StdDevCompareDatasets -qm` |

## Handoff notes

- Rendered files should live under `content/media/animations/week04/media/videos/<SceneName>/480p15/` when using the default Manim config.
- Export settings can be bumped to `-qh` before shipping to ensure visual crispness in the UIKit app.
- Coordinate with the iOS team to verify playback sizing; all scenes use text elements sized for 16:9 output.
- If time allows, extend Lesson 2 and Lesson 3 animations with voice-over scripts in `docs/v1.0/content/` (future task).
