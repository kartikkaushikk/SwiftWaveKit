import SwiftUI
import WaveKit

struct WaveQuestLevel5Demo: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // 3D Modulated Wave using WaveView + modifiers
                let carrier = WaveFunction.sine(frequency: 5.0)
                let modulator = WaveFunction { x in 1.0 + 0.8 * sin(0.5 * x) }
                let combined = modulator * carrier
                
                WaveView(combined)
                    .waveform(amplitude: 1.2)
                    .waveStyle(WaveStyle(color: .purple))
                    .animated(speed: 1.0)
                    .gridStyle(.dense)
                    .frame(height: 280)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .padding(.horizontal, 20)
                
                CodeSnippetView(code: """
                let carrier = WaveFunction.sine(frequency: 5.0)
                let modulator = WaveFunction { x in 
                    1.0 + 0.8 * sin(0.5 * x) 
                }
                let combined = modulator * carrier
                
                WaveView(combined)
                    .waveform(amplitude: 1.2)
                    .waveStyle(WaveStyle(color: .purple))
                    .animated(speed: 1.0)
                    .gridStyle(.dense)
                """)
                
                Spacer()
            }
            .padding(.top, 20)
        }
        .navigationTitle("Amplitude Modulation")
        .navigationBarTitleDisplayMode(.inline)

    }
}

struct WaveQuestLevel5Demo_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            WaveQuestLevel5Demo()
        }
    }
}
