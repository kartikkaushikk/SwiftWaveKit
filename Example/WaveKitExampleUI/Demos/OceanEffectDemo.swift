import SwiftUI
import WaveKit

struct OceanEffectDemo: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 3D Interference Wave using WaveView + modifiers
                let userFunction = WaveFunction.sine(frequency: 2.0)
                let targetFunction = WaveFunction.sine(frequency: 2.5)
                
                WaveView(userFunction)
                    .waveform(amplitude: 1.0)
                    .waveStyle(WaveStyle(color: .cyan))
                    .interference(with: TargetWave(function: targetFunction, amplitude: 1.0, frequency: 2.5, color: .blue))
                    .isAligning(true)
                    .animated(speed: 1.0)
                    .gridStyle(.subtle)
                    .frame(height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .padding(.horizontal, 20)
                
                CodeSnippetView(code: """
                let userFunction = WaveFunction.sine(frequency: 2.0)
                let targetFunction = WaveFunction.sine(frequency: 2.5)
                
                WaveView(userFunction)
                    .waveform(amplitude: 1.0)
                    .waveStyle(WaveStyle(color: .cyan))
                    .interference(with: TargetWave(
                        function: targetFunction,
                        amplitude: 1.0,
                        frequency: 2.5,
                        color: .blue
                    ))
                    .isAligning(true)
                """)
                
                Spacer()
            }
            .padding(.top, 20)
        }
        .navigationTitle("Ocean & Interference")
        .navigationBarTitleDisplayMode(.inline)

    }
}

struct OceanEffectDemo_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            OceanEffectDemo()
        }
    }
}
