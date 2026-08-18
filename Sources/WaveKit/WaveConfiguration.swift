//
//  WaveConfiguration.swift
//  WaveKit
//
//  A value type holding all customization parameters for a WaveView.
//  This is used internally by the environment-based modifier system.
//

import SwiftUI

/// The direction of a gradient applied to a wave.
public enum WaveGradientDirection: Sendable {
    /// Gradient runs horizontally (left to right).
    case horizontal
    /// Gradient runs vertically (top to bottom).
    case vertical
}

/// The type of gradient applied to a wave.
public enum WaveGradientStyle: Sendable {
    /// A linear gradient in the specified direction.
    case linear
    /// A radial gradient emanating from the center.
    case radial
    /// An angular (conic) gradient sweeping around the center.
    case angular
}

/// Holds the gradient configuration for a wave.
public struct WaveGradient: Sendable, Equatable {
    /// The SwiftUI gradient (color stops).
    public var gradient: Gradient
    /// The gradient rendering style.
    public var style: WaveGradientStyle
    /// The gradient direction (used for linear style).
    public var direction: WaveGradientDirection

    public init(
        gradient: Gradient,
        style: WaveGradientStyle = .linear,
        direction: WaveGradientDirection = .vertical
    ) {
        self.gradient = gradient
        self.style = style
        self.direction = direction
    }

    public static func == (lhs: WaveGradient, rhs: WaveGradient) -> Bool {
        // Gradient doesn't conform to Equatable by default, compare by identity
        lhs.style == rhs.style && lhs.direction == rhs.direction
    }
}

/// A target wave used for interference comparisons.
public struct TargetWave: Sendable {
    public var function: WaveFunction
    public var amplitude: Double
    public var frequency: Double
    public var phase: Double
    public var color: Color
    
    public init(function: WaveFunction, amplitude: Double = 1.0, frequency: Double = 1.0, phase: Double = 0.0, color: Color = .white) {
        self.function = function
        self.amplitude = amplitude
        self.frequency = frequency
        self.phase = phase
        self.color = color
    }
}

/// Styling configuration for a wave.
public struct WaveStyle: Sendable, Equatable {
    public var color: Color
    public var lineWidth: CGFloat
    public var opacity: Double
    public var glowIntensity: Double
    public var gradient: WaveGradient?

    public init(color: Color = .primary, lineWidth: CGFloat = 2.0, opacity: Double = 1.0, glowIntensity: Double = 0.0, gradient: WaveGradient? = nil) {
        self.color = color
        self.lineWidth = lineWidth
        self.opacity = opacity
        self.glowIntensity = glowIntensity
        self.gradient = gradient
    }

    public static let neon = WaveStyle(color: .cyan, lineWidth: 2.0, opacity: 1.0, glowIntensity: 1.5, gradient: nil)
    public static let minimal = WaveStyle(color: .primary, lineWidth: 1.0, opacity: 0.8, glowIntensity: 0.0, gradient: nil)
}

/// Styling configuration for the 3D perspective floor grid.
public struct WaveGridStyle: Sendable, Equatable {
    public var color: Color
    public var lineWidth: CGFloat
    public var opacity: Double
    public var lineCount: Int

    public init(color: Color = .gray, lineWidth: CGFloat = 1.0, opacity: Double = 0.3, lineCount: Int = 12) {
        self.color = color
        self.lineWidth = lineWidth
        self.opacity = opacity
        self.lineCount = lineCount
    }

    public static let subtle = WaveGridStyle(color: .gray, lineWidth: 1.0, opacity: 0.15, lineCount: 8)
    public static let dense  = WaveGridStyle(color: .cyan, lineWidth: 1.0, opacity: 0.4, lineCount: 24)
}

/// Styling configuration for the vertical drop lines anchoring the wave.
public struct WaveDropLineStyle: Sendable, Equatable {
    public var color: Color
    public var lineWidth: CGFloat
    public var opacity: Double
    public var lineCount: Int

    public init(color: Color = .gray, lineWidth: CGFloat = 1.0, opacity: Double = 0.3, lineCount: Int = 30) {
        self.color = color
        self.lineWidth = lineWidth
        self.opacity = opacity
        self.lineCount = lineCount
    }

    public static let subtle = WaveDropLineStyle(color: .gray, lineWidth: 1.0, opacity: 0.15, lineCount: 15)
    public static let dense  = WaveDropLineStyle(color: .cyan, lineWidth: 1.0, opacity: 0.4, lineCount: 60)
}

/// Configuration for the 3D camera.
public struct WaveCameraConfig: Sendable, Equatable {
    public var azimuth: Double
    public var elevation: Double
    public var distance: Double

    public init(azimuth: Double = 45.0, elevation: Double = 25.0, distance: Double = 80.0) {
        self.azimuth = azimuth
        self.elevation = elevation
        self.distance = distance
    }

    public static let front = WaveCameraConfig(azimuth: 0, elevation: 0, distance: 80.0)
    public static let iso = WaveCameraConfig(azimuth: -60, elevation: -15, distance: 20.0)
}

/// Holds all configuration parameters for rendering a wave.
///
/// This type is used internally by the environment-based modifier system.
/// You typically don't create this directly — instead, use the view modifiers
/// on `WaveView`.
public struct WaveConfiguration: Sendable {
    public var amplitude: Double = 1.0
    public var frequency: Double = 1.0
    public var phase: Double = 0.0
    public var xRange: ClosedRange<Double> = 0...(2 * .pi)
    public var sampleCount: Int = 200
    public var lineWidth: CGFloat = 2.0
    public var strokeColor: Color = .primary
    public var waveGradient: WaveGradient?
    public var verticalOffset: Double = 0.0
    public var isAnimated: Bool = true
    public var animationSpeed: Double = 1.0
    
    // 3D Visualizer settings
    public var renderMode: WaveRenderMode = .threeDimensional
    public var progress: Double = 1.0
    public var isAligning: Bool = false
    public var targetAmplitude: Double = 1.0
    public var targetFrequency: Double = 1.0
    public var targetPhase: Double = 0.0
    public var targetColor: Color = .white
    public var targetFunction: WaveFunction? = nil

    public init() {}
}

// MARK: - SwiftUI Environment Keys

struct WaveAmplitudeKey: EnvironmentKey {
    static let defaultValue: Double = 1.0
}

struct WaveFrequencyKey: EnvironmentKey {
    static let defaultValue: Double = 1.0
}

struct WavePhaseKey: EnvironmentKey {
    static let defaultValue: Double = 0.0
}

struct WaveXRangeKey: EnvironmentKey {
    static let defaultValue: ClosedRange<Double> = 0...(2 * .pi)
}

struct WaveSampleCountKey: EnvironmentKey {
    static let defaultValue: Int = 200
}

struct WaveLineWidthKey: EnvironmentKey {
    static let defaultValue: CGFloat = 2.0
}

struct WaveStrokeColorKey: EnvironmentKey {
    static let defaultValue: Color = .primary
}

struct WaveOpacityKey: EnvironmentKey {
    static let defaultValue: Double = 1.0
}

struct WaveGlowIntensityKey: EnvironmentKey {
    static let defaultValue: Double = 0.0
}

struct WaveGradientKey: EnvironmentKey {
    static let defaultValue: WaveGradient? = nil
}

struct WaveVerticalOffsetKey: EnvironmentKey {
    static let defaultValue: Double = 0.0
}

struct WaveAnimatedKey: EnvironmentKey {
    static let defaultValue: Bool = true
}

struct WaveAnimationSpeedKey: EnvironmentKey {
    static let defaultValue: Double = 1.0
}

extension EnvironmentValues {
    var waveAmplitude: Double {
        get { self[WaveAmplitudeKey.self] }
        set { self[WaveAmplitudeKey.self] = newValue }
    }

    var waveFrequency: Double {
        get { self[WaveFrequencyKey.self] }
        set { self[WaveFrequencyKey.self] = newValue }
    }

    var wavePhase: Double {
        get { self[WavePhaseKey.self] }
        set { self[WavePhaseKey.self] = newValue }
    }

    var waveXRange: ClosedRange<Double> {
        get { self[WaveXRangeKey.self] }
        set { self[WaveXRangeKey.self] = newValue }
    }

    var waveSampleCount: Int {
        get { self[WaveSampleCountKey.self] }
        set { self[WaveSampleCountKey.self] = newValue }
    }

    var waveLineWidth: CGFloat {
        get { self[WaveLineWidthKey.self] }
        set { self[WaveLineWidthKey.self] = newValue }
    }

    var waveStrokeColor: Color {
        get { self[WaveStrokeColorKey.self] }
        set { self[WaveStrokeColorKey.self] = newValue }
    }
    
    var waveOpacity: Double {
        get { self[WaveOpacityKey.self] }
        set { self[WaveOpacityKey.self] = newValue }
    }
    
    var waveGlowIntensity: Double {
        get { self[WaveGlowIntensityKey.self] }
        set { self[WaveGlowIntensityKey.self] = newValue }
    }

    var waveGradient: WaveGradient? {
        get { self[WaveGradientKey.self] }
        set { self[WaveGradientKey.self] = newValue }
    }

    var waveVerticalOffset: Double {
        get { self[WaveVerticalOffsetKey.self] }
        set { self[WaveVerticalOffsetKey.self] = newValue }
    }

    var waveAnimated: Bool {
        get { self[WaveAnimatedKey.self] }
        set { self[WaveAnimatedKey.self] = newValue }
    }

    var waveAnimationSpeed: Double {
        get { self[WaveAnimationSpeedKey.self] }
        set { self[WaveAnimationSpeedKey.self] = newValue }
    }
}

// MARK: - 3D Renderer Extensions

public enum WaveRenderMode: Sendable {
    case twoDimensional
    case threeDimensional
}

struct WaveRenderModeKey: EnvironmentKey {
    static let defaultValue: WaveRenderMode = .threeDimensional
}

struct WaveProgressKey: EnvironmentKey {
    static let defaultValue: Double = 1.0
}

struct WaveIsAligningKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

struct WaveTargetAmplitudeKey: EnvironmentKey {
    static let defaultValue: Double = 1.0
}

struct WaveTargetFrequencyKey: EnvironmentKey {
    static let defaultValue: Double = 1.0
}

struct WaveTargetPhaseKey: EnvironmentKey {
    static let defaultValue: Double = 0.0
}

struct WaveTargetColorKey: EnvironmentKey {
    static let defaultValue: Color = .white
}

struct WaveTargetFunctionKey: EnvironmentKey {
    static let defaultValue: WaveFunction? = nil
}

struct WaveGridColorKey: EnvironmentKey { static let defaultValue: Color = .gray }
struct WaveGridLineWidthKey: EnvironmentKey { static let defaultValue: CGFloat = 1.0 }
struct WaveGridOpacityKey: EnvironmentKey { static let defaultValue: Double = 0.3 }
struct WaveGridLineCountKey: EnvironmentKey { static let defaultValue: Int = 12 }

struct WaveDropLineColorKey: EnvironmentKey { static let defaultValue: Color = .gray }
struct WaveDropLineLineWidthKey: EnvironmentKey { static let defaultValue: CGFloat = 1.0 }
struct WaveDropLineOpacityKey: EnvironmentKey { static let defaultValue: Double = 0.3 }
struct WaveDropLineCountKey: EnvironmentKey { static let defaultValue: Int = 30 }

struct WaveCameraAngleKey: EnvironmentKey { static let defaultValue: WaveCameraConfig = .iso }

extension EnvironmentValues {
    public var waveRenderMode: WaveRenderMode {
        get { self[WaveRenderModeKey.self] }
        set { self[WaveRenderModeKey.self] = newValue }
    }
    public var waveProgress: Double {
        get { self[WaveProgressKey.self] }
        set { self[WaveProgressKey.self] = newValue }
    }
    public var waveIsAligning: Bool {
        get { self[WaveIsAligningKey.self] }
        set { self[WaveIsAligningKey.self] = newValue }
    }
    public var waveTargetAmplitude: Double {
        get { self[WaveTargetAmplitudeKey.self] }
        set { self[WaveTargetAmplitudeKey.self] = newValue }
    }
    public var waveTargetFrequency: Double {
        get { self[WaveTargetFrequencyKey.self] }
        set { self[WaveTargetFrequencyKey.self] = newValue }
    }
    public var waveTargetPhase: Double {
        get { self[WaveTargetPhaseKey.self] }
        set { self[WaveTargetPhaseKey.self] = newValue }
    }
    public var waveTargetColor: Color {
        get { self[WaveTargetColorKey.self] }
        set { self[WaveTargetColorKey.self] = newValue }
    }
    public var waveTargetFunction: WaveFunction? {
        get { self[WaveTargetFunctionKey.self] }
        set { self[WaveTargetFunctionKey.self] = newValue }
    }
    
    public var waveGridColor: Color {
        get { self[WaveGridColorKey.self] }
        set { self[WaveGridColorKey.self] = newValue }
    }
    public var waveGridLineWidth: CGFloat {
        get { self[WaveGridLineWidthKey.self] }
        set { self[WaveGridLineWidthKey.self] = newValue }
    }
    public var waveGridOpacity: Double {
        get { self[WaveGridOpacityKey.self] }
        set { self[WaveGridOpacityKey.self] = newValue }
    }
    public var waveGridLineCount: Int {
        get { self[WaveGridLineCountKey.self] }
        set { self[WaveGridLineCountKey.self] = newValue }
    }

    public var waveDropLineColor: Color {
        get { self[WaveDropLineColorKey.self] }
        set { self[WaveDropLineColorKey.self] = newValue }
    }
    public var waveDropLineLineWidth: CGFloat {
        get { self[WaveDropLineLineWidthKey.self] }
        set { self[WaveDropLineLineWidthKey.self] = newValue }
    }
    public var waveDropLineOpacity: Double {
        get { self[WaveDropLineOpacityKey.self] }
        set { self[WaveDropLineOpacityKey.self] = newValue }
    }
    public var waveDropLineCount: Int {
        get { self[WaveDropLineCountKey.self] }
        set { self[WaveDropLineCountKey.self] = newValue }
    }
    public var waveCameraAngle: WaveCameraConfig {
        get { self[WaveCameraAngleKey.self] }
        set { self[WaveCameraAngleKey.self] = newValue }
    }
}
