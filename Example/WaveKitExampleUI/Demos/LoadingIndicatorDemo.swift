import SwiftUI
import Combine
import WaveKit

struct LoadingIndicatorDemo: View {
    @State private var isSpinning: Bool = false
    @State private var scale: CGFloat = 1.0
    
    // We will automatically pulse the amplitude using a timer
    @State private var amplitude: Double = 1.0
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                // Spinner using WaveView + modifiers
                VStack(spacing: 30) {
                    WaveView(.sine)
                        .waveform(amplitude: amplitude, frequency: 4.0)
                        .waveStyle(WaveStyle(color: .cyan))
                        .animated(speed: 1.0)
                        .gridStyle(.init(lineCount: 0))
                        .dropLineStyle(.init(lineCount: 0))
                        .frame(width: 220, height: 220)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .scaleEffect(scale)
                        .rotationEffect(Angle(degrees: isSpinning ? 360 : 0))
                    
                    Text("Loading Asset Data...")
                        .font(.system(.headline, design: .rounded))
                        .foregroundColor(.cyan)
                }
                
                CodeSnippetView(code: """
                WaveView(.sine)
                    .waveform(
                        amplitude: self.amplitude, 
                        frequency: 4.0
                    )
                    .waveStyle(WaveStyle(color: .cyan))
                    .animated(speed: 1.0)
                    .gridStyle(.init(lineCount: 0))
                    .dropLineStyle(.init(lineCount: 0))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .scaleEffect(scale)
                """)
                
                Spacer()
            }
            .padding(.top, 20)
        }
        .navigationTitle("Loading Indicators")
        .navigationBarTitleDisplayMode(.inline)

        .onReceive(timer) { time in
            let factor = sin(time.timeIntervalSince1970 * 2.0 * 1.5)
            amplitude = 1.0 + factor * 0.6
        }
        .onAppear {
            withAnimation(.linear(duration: 4.0).repeatForever(autoreverses: false)) {
                isSpinning = true
            }
            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                scale = 1.2
            }
        }
    }
}

struct LoadingIndicatorDemo_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LoadingIndicatorDemo()
        }
    }
}
