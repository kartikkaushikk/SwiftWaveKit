import SwiftUI
import WaveKit

struct CameraAngleDemo: View {
    @State private var azimuth: Double = 45.0
    @State private var elevation: Double = 25.0
    @State private var distance: Double = 80.0

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // 3D Wave with camera angle controls
                let function = WaveFunction.damped(decay: 0.2, frequency: 3.0)
                
                WaveView(function)
                    .waveform(amplitude: 1.5, frequency: 3.0)
                    .waveStyle(WaveStyle(color: .orange))
                    .animated(speed: 1.0)
                    .gridStyle(.dense)
                    .cameraAngle(WaveCameraConfig(azimuth: azimuth, elevation: elevation, distance: distance))
                    .frame(height: 280)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .padding(.horizontal, 20)
                
                VStack(spacing: 16) {
                    sliderRow(title: "Side (Azimuth)", value: $azimuth, range: -180...180)
                    sliderRow(title: "Tilt (Elevation)", value: $elevation, range: -90...90)
                    sliderRow(title: "Zoom (Distance)", value: $distance, range: 10...150)
                }
                .padding(.horizontal, 24)
                
                Spacer()
            }
            .padding(.top, 20)
        }
        .navigationTitle("Camera Angle")
        .navigationBarTitleDisplayMode(.inline)

    }

    private func sliderRow(title: String, value: Binding<Double>, range: ClosedRange<Double>) -> some View {
        VStack(spacing: 4) {
            HStack {
                Text(title)
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.secondary)
                Spacer()
                Text(String(format: "%.1f", value.wrappedValue))
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.primary)
            }
            Slider(value: value, in: range)
                .accentColor(.orange)
        }
    }
}

struct CameraAngleDemo_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CameraAngleDemo()
        }
    }
}
