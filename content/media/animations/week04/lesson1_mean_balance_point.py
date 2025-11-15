from manim import Brace, DOWN, Dot, FadeIn, FadeOut, NumberLine, Scene, Tex, UP, VGroup, YELLOW


class Lesson1MeanBalancePoint(Scene):
    """Show the arithmetic mean as the balance point of sample data."""

    def construct(self) -> None:
        title = Tex(r"平均はデータのバランスポイント")
        title.to_edge(UP)
        self.play(FadeIn(title))

        number_line = NumberLine(x_range=[0, 10, 1], length=8)
        number_line.shift(0.5 * DOWN)
        self.play(FadeIn(number_line))

        sample_values = [2, 4, 7, 9]
        dots = VGroup()
        for value in sample_values:
            dot = Dot(point=number_line.number_to_point(value), color=YELLOW)
            dots.add(dot)
        self.play(FadeIn(dots))

        mean_value = sum(sample_values) / len(sample_values)
        mean_marker = Tex(r"\bar{x}=5.5")
        mean_marker.next_to(number_line.number_to_point(mean_value), UP)

        brace = Brace(number_line, direction=DOWN, buff=0.2)
        mean_text = brace.get_tex(r"バランス点 = \frac{2+4+7+9}{4}")

        self.play(FadeIn(brace), FadeIn(mean_text))
        self.play(FadeIn(mean_marker))
        self.wait(2)

        conclusion = Tex(r"重み付き平均もバランスで理解できる！")
        conclusion.next_to(number_line, DOWN)
        self.play(FadeIn(conclusion))
        self.wait(2)
        self.play(FadeOut(VGroup(brace, mean_text, mean_marker, conclusion, dots)))
        self.wait(1)
