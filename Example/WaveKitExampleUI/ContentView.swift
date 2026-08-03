import SwiftUI
import WaveKit

public struct ContentView: View {
    @State private var amplitude: Double = 1.2
    @State private var frequency: Double = 2.5
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            Form {
                // Showcase Header
                Section {
                    WaveView(.sine)
                        .waveform(amplitude: amplitude, frequency: frequency)
                        .waveStyle(WaveStyle(color: .cyan))
                        .animated(speed: 1.0)
                        .frame(height: 180)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                }
                
                // Demos
				Section("Visualizations") {
					List{
						NavigationLink("Basic Sine", destination: BasicSineDemo())
						NavigationLink("Multiple Waves", destination: MultipleWavesDemo())
						NavigationLink("Camera Angle", destination: CameraAngleDemo())
						NavigationLink("Ocean Effect", destination: OceanEffectDemo())
						NavigationLink("ECG Heartbeat", destination: ECGStyleDemo())
						NavigationLink("Z-Depth Progress", destination: ProgressWaveDemo())
					}
				}
            }
            .navigationTitle("WaveKit")
            #if os(macOS)
            .frame(width: 330)
            #endif
        }
        .tint(.cyan)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
