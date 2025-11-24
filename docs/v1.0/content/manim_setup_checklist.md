# Manim Setup Checklist (Week 3 Codex CLI)

This checklist captures the steps Codex CLI followed during Week 3 to prepare
Manim for animation production. The goal is to ensure Claude Code can reproduce
the environment locally when integrating exported videos in Week 4.

## 1. Environment preparation

1. Install Python 3.11 (Homebrew on macOS, `pyenv`, or system package manager).
2. Create a dedicated virtual environment:
   ```bash
   python3.11 -m venv ~/.venvs/stat-ease-manim
   source ~/.venvs/stat-ease-manim/bin/activate
   ```
3. Upgrade packaging tools:
   ```bash
   pip install --upgrade pip setuptools wheel
   ```

## 2. Manim installation

```bash
pip install "manim[browser]"==0.18.1
```

- The `[browser]` extra pulls in Jupyter and rendering helpers used for quick
  previews.
- Confirm installation with `manim --version` (expected output: `Manim Community v0.18.1`).

## 3. Repository scaffold

```
content/
  media/
    animations/
      week03/
        README.md        # Export log (created during rendering)
        sample_scene.py  # Reference implementation for QA
```

- The `animations/week03/README.md` file will record render commands and output
  filenames when assets are produced in Week 4.
- `sample_scene.py` contains a minimal class to validate rendering on CI or the
  designer's machine.

## 4. Sample animation smoke test

Run the following command inside the virtual environment from the repository
root to ensure FFmpeg and OpenGL dependencies resolve correctly:

```bash
manim content/media/animations/week03/sample_scene.py SampleScene -qm
```

Expected output assets:

- `content/media/animations/week03/media/videos/sample_scene/480p15/SampleScene.mp4`
- `content/media/animations/week03/media/text/SampleScene.json`

## 5. Troubleshooting notes

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| `ImportError: libcairo` | Missing Cairo library | macOS: `brew install cairo`; Ubuntu: `sudo apt-get install libcairo2-dev` |
| `OSError: ffmpeg not found` | FFmpeg not installed | Install via package manager (`brew install ffmpeg`, `sudo apt-get install ffmpeg`) |
| Blank window / OpenGL errors | GPU driver issues on Windows | Use `--renderer=cairo` flag asフォールバック |

## 6. Next steps

- Draft storyboards for priority lessons (平均・分散・標準偏差) using the static
  figures created in Weeks 1〜3.
- Coordinate with Claude Code on preferred resolution/bitrate before final
  rendering in Week 4.
