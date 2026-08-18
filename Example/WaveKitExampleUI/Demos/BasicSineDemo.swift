import SwiftUI
import WaveKit

struct BasicSineDemo: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // 3D Wave using WaveView + modifiers
                WaveView(.sine)
                    .waveform(amplitude: 1.0, frequency: 2.0)
                    .waveStyle(.neon)
                    .animated(speed: 1.0)
                    .gridStyle(.subtle)
                    .frame(height: 280)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .padding(.horizontal, 20)
                
                CodeSnippetView(code: """
                WaveView(.sine)
                    .waveform(amplitude: 1.0, frequency: 2.0)
                    .waveStyle(.neon)
                    .animated(speed: 1.0)
                    .gridStyle(.subtle)
                """)
                
                Spacer()
            }
            .padding(.top, 20)
        }
        .navigationTitle("Basic Sine Wave")
        .navigationBarTitleDisplayMode(.inline)

    }
}

struct DemoSlider: View {
    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    var format: String = "%.2f"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                Spacer()
                Text(String(format: format, value))
                    .font(.system(.subheadline, design: .monospaced))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            Slider(value: $value, in: range)
                .tint(.cyan)
        }
    }
}

struct BasicSineDemo_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            BasicSineDemo()
        }
    }
}
