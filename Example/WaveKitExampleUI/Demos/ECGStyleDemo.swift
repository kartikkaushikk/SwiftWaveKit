import SwiftUI
import WaveKit

struct ECGStyleDemo: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // 3D ECG using WaveView + modifiers
                WaveView(ecgFunction)
                    .waveform(amplitude: 1.0)
                    .waveStyle(WaveStyle(color: .green))
                    .animated(speed: 1.0)
                    .gridStyle(.dense)
                    .frame(height: 280)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .padding(.horizontal, 20)
                
                CodeSnippetView(code: """
                WaveView(ecgFunction)
                    .waveform(amplitude: 1.0)
                    .waveStyle(WaveStyle(color: .green))
                    .animated(speed: 1.0)
                    .gridStyle(.dense)
                """)
                
                Spacer()
            }
            .padding(.top, 20)
        }
        .navigationTitle("ECG Heartbeat")
        .navigationBarTitleDisplayMode(.inline)

    }
    
    // Fallback ECG wave definition (used if ever rendered in 2D)
    var ecgFunction: WaveFunction {
        WaveFunction { x in
            let period = 2.0 * .pi
            let t = x.truncatingRemainder(dividingBy: period)
            let normalizedT = t < 0 ? t + period : t
            
            var y = 0.0
            y += 0.15 * exp(-pow((normalizedT - 1.0) / 0.2, 2.0))
            y -= 0.15 * exp(-pow((normalizedT - 2.0) / 0.05, 2.0))
            y += 1.5 * exp(-pow((normalizedT - 2.2) / 0.1, 2.0))
            y -= 0.3 * exp(-pow((normalizedT - 2.4) / 0.05, 2.0))
            y += 0.25 * exp(-pow((normalizedT - 4.0) / 0.3, 2.0))
            return y
        }
    }
}

struct ECGStyleDemo_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ECGStyleDemo()
        }
    }
}
