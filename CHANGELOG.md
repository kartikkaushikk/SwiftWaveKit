# Changelog

All notable changes to WaveKit are documented here. Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project uses [Semantic Versioning](https://semver.org/).

For the full reasoning behind these changes, see [docs/DESIGN.md](docs/DESIGN.md).

---

## [1.0.0] - Stable Release

### Added
- `.waveform(amplitude:frequency:phase:)` combinator modifier.
- `WaveStyle` struct (`.waveStyle(_:)`) consolidating color, line width, gradient, opacity, and glow intensity. Presets: `.neon`, `.minimal`.
- `WaveGridStyle` struct (`.gridStyle(_:)`) for the 3D perspective grid — color, line width, opacity, line count. Presets: `.subtle`, `.dense`.
- `WaveDropLineStyle` struct (`.dropLineStyle(_:)`) for vertical drop lines, independent of grid. Presets: `.subtle`, `.dense`.
- `WaveCameraConfig` struct (`.cameraAngle(_:)`) for azimuth, elevation, and distance. Presets: `.front`, `.iso`.
- `TargetWave` struct and `.interference(with:)` modifier, replacing 7 separate target/interference modifiers.
- `.render2D()` modifier as the explicit opt-out of the new 3D-by-default rendering.

### Changed
- **3D rendering is now the default.** Previously `WaveView` rendered 2D by default and required `.renderMode3D(true)` to enable 3D. Use `.render2D()` to opt out.
- `.animated()` and `.animationSpeed()` merged into `.animated(speed:)`.

### Removed
- `.isECG(_:)` and `.isPureTone(_:)` modifiers. These hardcoded specific visual "looks" into the core API. Equivalent results are now achieved by composing `WaveFunction` presets — see [Composing Custom Wave Shapes](README.md#composing-custom-wave-shapes) in the README.
- `.renderMode3D(_:)` and the internal `.render3D()` wrapper. No longer needed since 3D is the default; use `.render2D()` for the 2D path.
- `.showGrid(_:)` and `WaveShowGridKey`. **No direct replacement** — grid and drop-line visibility are now controlled independently via `WaveGridStyle.lineCount == 0` and `WaveDropLineStyle.lineCount == 0`. See migration table in [README](README.md#migrating-from-pre-10-modifiers).

### Deprecated
- `.amplitude()`, `.frequency()`, `.phase()` — use `.waveform(amplitude:frequency:phase:)`. Still functional, marked `@available(*, deprecated, renamed:)`.
- `.waveColor()`, `.waveLineWidth()`, `.gradient()`, `.gradientDirection()` — use `.waveStyle(_:)`. Still functional.
- `.showInterference()`, `.targetFunction()`, `.targetAmplitude()`, `.targetFrequency()`, `.targetPhase()`, `.targetColor()`, `.isAligning()` — use `.interference(with:)`. Still functional.

### Migration Notes
- If you called `.renderMode3D(true)`, you can simply remove the call — it's now the default.
- If you relied on `.showGrid(false)`, switch to `.gridStyle(.init(lineCount: 0))` and/or `.dropLineStyle(.init(lineCount: 0))` depending on which element you meant to hide.
- If you used `.isECG(true)` or `.isPureTone(true)`, see the new [Composing Custom Wave Shapes](README.md#composing-custom-wave-shapes) section for equivalent `WaveFunction` recipes.

---

## [0.1.2] - prior release
- Initial public modifier surface: 24 modifiers across general/2D, animation, 3D render, and interference/target groups. See [docs/DESIGN.md](docs/DESIGN.md) for the full before/after audit.
