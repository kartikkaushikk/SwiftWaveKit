import SwiftUI
import WaveKit

struct ProgressWaveDemo: View {
    @State private var progress: Double = 0.5
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // 3D Wave with progress
                ZStack {
                    WaveView(.sine)
                        .waveform(amplitude: 1.2, frequency: 3.0)
                        .waveStyle(WaveStyle(color: .cyan))
                        .animated(speed: 1.0)
                        .progress(progress)
                        .gridStyle(.subtle)
                        .frame(height: 280)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .task {
                            while progress < 1.0 {
                                do {
                                    let next = try await progressFunction(progress: progress)
                                    withAnimation(.easeInOut(duration: 0.6)) {
                                        progress = min(next, 1.0)
                                    }
                                } catch {
                                    break
                                }
                            }
                        }
                    
                    // Centered percentage overlay
                    Text("\(Int(progress * 100))%")
                        .font(.system(size: 64, weight: .black, design: .rounded))
                        .foregroundColor(.white.opacity(0.15))
                        .allowsHitTesting(false)
                }
                .padding(.horizontal, 20)
                
                CodeSnippetView(code: """
                WaveView(.sine)
                    .waveform(amplitude: 1.2, frequency: 3.0)
                    .waveStyle(WaveStyle(color: .cyan))
                    .animated(speed: 1.0)
                    .progress(progress)
                    .gridStyle(.subtle)
                """)
                
                Spacer()
            }
            .padding(.top, 20)
        }
        .navigationTitle("Z-Depth Progress")
        .navigationBarTitleDisplayMode(.inline)

    }
}

func progressFunction(progress: Double) async throws -> Double {
    try await Task.sleep(nanoseconds: 3_000_000_000)
    return progress + 0.25
}

struct ProgressWaveDemo_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ProgressWaveDemo()
        }
    }
}
