from manim import BLUE, DOWN, FadeIn, FadeOut, Line, NumberLine, Scene, Square, Tex, UP, VGroup, YELLOW


class Lesson2VarianceSpreadVisual(Scene):
    """Visualize how variance grows with spread from the mean."""

    def construct(self) -> None:
        title = Tex(r"分散は平均からの離れ具合を二乗で評価").to_edge(UP)
        self.play(FadeIn(title))

        number_line = NumberLine(x_range=[-5, 5, 1], length=8)
        number_line.shift(0.3 * DOWN)
        self.play(FadeIn(number_line))

        mean_point = number_line.number_to_point(0)
        mean = Line(mean_point, mean_point + 1.2 * UP, color=YELLOW)
        mean_label = Tex(r"平均").next_to(mean, direction=UP)
        self.play(FadeIn(mean), FadeIn(mean_label))

        points = [-1, 1, -4, 3]
        squares = VGroup()
        for value in points:
            start = number_line.number_to_point(value)
            square = Square(side_length=0.5 + abs(value) * 0.12, color=BLUE)
            square.move_to(start + 0.8 * UP)
            text = Tex(fr"({value})^2").scale(0.6).move_to(square.get_center())
            pair = VGroup(square, text)
            squares.add(pair)
        self.play(FadeIn(squares))
        self.wait(2)

        summary = Tex(r"離れ具合が大きいほど、二乗で重みが増える！")
        summary.next_to(number_line, DOWN)
        self.play(FadeIn(summary))
        self.wait(2)

        self.play(FadeOut(VGroup(squares, summary, mean, mean_label)))
        self.wait(1)
