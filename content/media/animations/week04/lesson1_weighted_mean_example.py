from manim import DOWN, FadeIn, FadeOut, MathTable, Scene, Tex, UP, VGroup


class Lesson1WeightedMeanExample(Scene):
    """Walk through a weighted mean calculation step by step."""

    def construct(self) -> None:
        title = Tex(r"加重平均の計算プロセス").to_edge(UP)
        self.play(FadeIn(title))

        table = MathTable(
            [["科目", "点数", "重み"],
             ["小テスト", "70", "1"],
             ["中間", "80", "2"],
             ["期末", "90", "3"]],
            include_outer_lines=True,
        )
        table.scale(0.8)
        self.play(FadeIn(table))

        formula = Tex(r"加重平均 = \frac{70\times1 + 80\times2 + 90\times3}{1+2+3}")
        formula.next_to(table, DOWN)
        self.play(FadeIn(formula))
        self.wait(2)

        simplification_steps = VGroup(
            Tex(r"= \frac{70 + 160 + 270}{6}"),
            Tex(r"= \frac{500}{6}"),
            Tex(r"\approx 83.3 点"),
        ).arrange(DOWN, center=False, aligned_edge="LEFT")
        simplification_steps.next_to(formula, DOWN)

        for step in simplification_steps:
            self.play(FadeIn(step))
            self.wait(0.8)

        conclusion = Tex(r"重要度に応じて平均がシフトする！").next_to(
            simplification_steps, DOWN
        )
        self.play(FadeIn(conclusion))
        self.wait(2)
        self.play(FadeOut(VGroup(table, formula, simplification_steps, conclusion)))
        self.wait(1)
