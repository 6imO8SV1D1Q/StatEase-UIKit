from manim import Brace, DOWN, FadeIn, FadeOut, MathTex, Scene, Tex, UP, VGroup


class Lesson2VarianceFormulaWalkthrough(Scene):
    """Derive the sample variance formula using step-by-step captions."""

    def construct(self) -> None:
        title = Tex(r"分散の計算手順").to_edge(UP)
        self.play(FadeIn(title))

        formula = MathTex(r"s^2 = \frac{\sum (x_i - \bar{x})^2}{n-1}")
        self.play(FadeIn(formula))
        self.wait(1.5)

        steps = VGroup(
            Tex(r"1. 平均 \(\bar{x}\) を求める"),
            Tex(r"2. 各データから平均を引き差を求める"),
            Tex(r"3. 差を二乗して合計"),
            Tex(r"4. データ数-1で割る"),
        ).arrange(DOWN, aligned_edge="LEFT", buff=0.6)
        steps.next_to(formula, DOWN)

        brace = Brace(steps, direction=DOWN)
        caption = brace.get_tex(r"サンプル分散の4ステップ")

        for step in steps:
            self.play(FadeIn(step))
            self.wait(0.6)

        self.play(FadeIn(brace), FadeIn(caption))
        self.wait(2)

        self.play(FadeOut(VGroup(formula, steps, brace, caption)))
        self.wait(1)
