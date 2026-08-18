import SwiftUI
import WaveKit

struct MultipleWavesDemo: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // 3D Composite Wave using WaveView + modifiers
                let combined = (WaveFunction.sine(frequency: 1.5) + WaveFunction.cosine(frequency: 3.0)) * 0.6
                
                WaveView(combined)
                    .waveform(amplitude: 1.0)
                    .waveStyle(WaveStyle(color: .white))
                    .animated(speed: 1.0)
                    .gridStyle(.dense)
                    .frame(height: 280)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .padding(.horizontal, 20)
                
                CodeSnippetView(code: """
                let combined = (
                    WaveFunction.sine(frequency: 1.5) + 
                    WaveFunction.cosine(frequency: 3.0)
                ) * 0.6
                
                WaveView(combined)
                    .waveform(amplitude: 1.0)
                    .waveStyle(WaveStyle(color: .white))
                    .animated(speed: 1.0)
                    .gridStyle(.dense)
                """)
                
                Spacer()
            }
            .padding(.top, 20)
        }
        .navigationTitle("Multiple Waves")
        .navigationBarTitleDisplayMode(.inline)

    }
}

struct MultipleWavesDemo_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MultipleWavesDemo()
        }
    }
}
