from manim import Axes, DOWN, FadeIn, FadeOut, RIGHT, Scene, Tex, UP, VGroup, WHITE, YELLOW


class Lesson3StdDevCompareDatasets(Scene):
    """Compare two datasets with identical means but different spreads."""

    def construct(self) -> None:
        title = Tex(r"平均は同じでもばらつきは違う").to_edge(UP)
        self.play(FadeIn(title))

        axes = Axes(x_range=[0, 6, 1], y_range=[0, 4, 1], x_length=6, y_length=3)
        axis_labels = axes.get_axis_labels(x_label_tex="値", y_label_tex="人数")
        self.play(FadeIn(axes), FadeIn(axis_labels))

        tight_plot = axes.plot_line_graph(
            x_values=[1, 2, 3, 4, 5],
            y_values=[0, 1, 3, 1, 0],
            add_vertex_dots=False,
            line_color=YELLOW,
        )
        wide_plot = axes.plot_line_graph(
            x_values=[0.5, 2, 3.5, 5],
            y_values=[0.5, 1.5, 1.5, 0.5],
            add_vertex_dots=False,
            line_color=WHITE,
        )
        self.play(FadeIn(tight_plot))
        self.play(FadeIn(wide_plot))

        labels = VGroup(
            Tex(r"Dataset A: $s=1.0$", color=YELLOW),
            Tex(r"Dataset B: $s=1.8$", color=WHITE),
        ).arrange(DOWN, aligned_edge="LEFT")
        labels.next_to(axes, direction=RIGHT)
        self.play(FadeIn(labels))
        self.wait(2)

        caption = Tex(r"平均は同じ3だが、標準偏差が示す広がりは異なる").next_to(axes, DOWN)
        self.play(FadeIn(caption))
        self.wait(2)
        self.play(FadeOut(VGroup(axes, axis_labels, tight_plot, wide_plot, labels, caption)))
        self.wait(1)
