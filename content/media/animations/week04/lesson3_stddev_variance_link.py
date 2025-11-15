from manim import Arrow, DOWN, FadeIn, FadeOut, MathTex, Scene, Tex, UP, VGroup


class Lesson3StdDevVarianceLink(Scene):
    """Connect variance and standard deviation visually."""

    def construct(self) -> None:
        title = Tex(r"標準偏差は分散の平方根").to_edge(UP)
        self.play(FadeIn(title))

        variance_box = VGroup(
            Tex(r"分散 $s^2$"),
            MathTex(r"s^2 = \frac{\sum (x_i - \bar{x})^2}{n-1}"),
        ).arrange(DOWN)

        std_box = VGroup(
            Tex(r"標準偏差 $s$"),
            MathTex(r"s = \sqrt{s^2}"),
        ).arrange(DOWN)
        std_box.next_to(variance_box, DOWN, buff=1.8)

        self.play(FadeIn(variance_box))
        self.wait(1)

        arrow = Arrow(start=variance_box.get_bottom(), end=std_box.get_top(), buff=0.2)
        arrow_label = Tex(r"$\sqrt{\ \ }$ で変換").next_to(arrow, RIGHT)
        self.play(FadeIn(arrow), FadeIn(arrow_label))
        self.play(FadeIn(std_box))
        self.wait(2)

        caption = Tex(r"単位を元に戻し、直感的なばらつきを示す").next_to(std_box, DOWN)
        self.play(FadeIn(caption))
        self.wait(2)
        self.play(FadeOut(VGroup(variance_box, std_box, arrow, arrow_label, caption)))
        self.wait(1)
