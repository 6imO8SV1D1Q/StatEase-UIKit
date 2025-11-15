from manim import Scene, Tex, FadeIn


class SampleScene(Scene):
    """Minimal scene to verify the Week 3 Manim environment."""

    def construct(self) -> None:
        title = Tex(r"StatEase UIKit - CV Demo")
        subtitle = Tex(r"Visualize variability with $CV = \frac{s}{\bar{x}}$")
        subtitle.next_to(title, direction="DOWN", buff=0.6)

        self.play(FadeIn(title))
        self.play(FadeIn(subtitle))
        self.wait(2)
