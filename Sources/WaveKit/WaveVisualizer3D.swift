import SwiftUI
import SceneKit

#if os(macOS)
import AppKit
public typealias PlatformColor = NSColor
public typealias PlatformViewRepresentable = NSViewRepresentable
#else
import UIKit
public typealias PlatformColor = UIColor
public typealias PlatformViewRepresentable = UIViewRepresentable
#endif

// Renders glowing 3D waveforms dynamically evaluated using WaveFunction,
// reading parameters from the SwiftUI environment.
struct WaveVisualizer3D: PlatformViewRepresentable {
    let function: WaveFunction

    @Environment(\.waveAmplitude) private var amplitude
    @Environment(\.waveFrequency) private var frequency
    @Environment(\.wavePhase) private var phase
    @Environment(\.waveStrokeColor) private var strokeColor
    @Environment(\.waveAnimated) private var isAnimated
    @Environment(\.waveAnimationSpeed) private var animationSpeed
    
    @Environment(\.waveProgress) private var progress
    @Environment(\.waveIsAligning) private var isAligning
    
    @Environment(\.waveTargetAmplitude) private var targetAmplitude
    @Environment(\.waveTargetFrequency) private var targetFrequency
    @Environment(\.waveTargetPhase) private var targetPhase
    @Environment(\.waveTargetColor) private var targetColor
    @Environment(\.waveTargetFunction) private var targetFunction
    
    @Environment(\.waveOpacity) private var waveOpacity
    @Environment(\.waveGlowIntensity) private var waveGlowIntensity
    
    @Environment(\.waveGridColor) private var gridColor
    @Environment(\.waveGridLineWidth) private var gridLineWidth
    @Environment(\.waveGridOpacity) private var gridOpacity
    @Environment(\.waveGridLineCount) private var gridLineCount
    
    @Environment(\.waveDropLineColor) private var dropLineColor
    @Environment(\.waveDropLineLineWidth) private var dropLineLineWidth
    @Environment(\.waveDropLineOpacity) private var dropLineOpacity
    @Environment(\.waveDropLineCount) private var dropLineCount
    
    @Environment(\.waveCameraAngle) private var cameraAngle

#if os(macOS)
    func makeNSView(context: Context) -> SCNView {
        return makeView(context: context)
    }
    func updateNSView(_ nsView: SCNView, context: Context) {
        updateView(nsView, context: context)
    }
#else
    func makeUIView(context: Context) -> SCNView {
        return makeView(context: context)
    }
    func updateUIView(_ uiView: SCNView, context: Context) {
        updateView(uiView, context: context)
    }
#endif

    func makeView(context: Context) -> SCNView {
        let scnView = SCNView()
        let scene   = SCNScene()
        scnView.scene = scene
        scnView.backgroundColor = .clear
        scnView.allowsCameraControl = true
        scnView.autoenablesDefaultLighting = false
        scnView.isJitteringEnabled = true

        let cameraNode = SCNNode()
        let camera     = SCNCamera()
        camera.zNear            = 0.1
        camera.zFar             = 200
        camera.bloomIntensity   = 2.2
        camera.bloomThreshold   = 0.1
        camera.bloomBlurRadius  = 10
        cameraNode.camera = camera

        cameraNode.position = SCNVector3(6.0, 10.0, 28.0)
        cameraNode.look(at: SCNVector3(6.0, -1.0, 5.0))
        scene.rootNode.addChildNode(cameraNode)

        let ambient     = SCNLight()
        ambient.type      = .ambient
        ambient.intensity = 150
        ambient.color     = PlatformColor.white
        let ambNode = SCNNode()
        ambNode.light = ambient
        scene.rootNode.addChildNode(ambNode)

        let gridNode = SCNNode(); gridNode.name = "grid"
        scene.rootNode.addChildNode(gridNode)

        let userWaveNode   = SCNNode(); userWaveNode.name   = "userWave"
        let targetWaveNode = SCNNode(); targetWaveNode.name = "targetWave"
        let dropLineNode   = SCNNode(); dropLineNode.name   = "dropLines"
        scene.rootNode.addChildNode(userWaveNode)
        scene.rootNode.addChildNode(targetWaveNode)
        scene.rootNode.addChildNode(dropLineNode)

        context.coordinator.setup(
            userWaveNode: userWaveNode,
            targetWaveNode: targetWaveNode,
            dropLineNode: dropLineNode,
            gridNode: gridNode,
            cameraNode: cameraNode,
            userColor: PlatformColor(strokeColor),
            targetColor: PlatformColor(targetColor)
        )
        scnView.delegate  = context.coordinator
        
        scnView.isPlaying = isAnimated
        scnView.rendersContinuously = true
        
        return scnView
    }

    func updateView(_ uiView: SCNView, context: Context) {
        uiView.isPlaying = isAnimated
        
        context.coordinator.updateParams(
            function: function,
            targetFunction: targetFunction,
            amp: Float(amplitude),
            freq: Float(frequency),
            ph: Float(phase),
            tAmp: Float(targetAmplitude),
            tFreq: Float(targetFrequency),
            tPh: Float(targetPhase),
            userColor: PlatformColor(strokeColor),
            targetColor: PlatformColor(targetColor),
            isAligning: isAligning,
            progress: Float(progress),
            animationSpeed: Float(animationSpeed),
            waveOpacity: Float(waveOpacity),
            waveGlowIntensity: Float(waveGlowIntensity),
            gridColor: PlatformColor(gridColor),
            gridOpacity: Float(gridOpacity),
            gridLineCount: gridLineCount,
            dropLineColor: PlatformColor(dropLineColor),
            dropLineOpacity: Float(dropLineOpacity),
            dropLineCount: dropLineCount,
            cameraAngle: cameraAngle
        )
    }

    func makeCoordinator() -> Coordinator { Coordinator() }



    // MARK: - Coordinator

    class Coordinator: NSObject, SCNSceneRendererDelegate {
        private var userWaveNode:   SCNNode?
        private var targetWaveNode: SCNNode?
        private var dropLineNode:   SCNNode?
        private var gridNode:       SCNNode?
        private var cameraNode:     SCNNode?

        private var function: WaveFunction = .init { _ in 0.0 }
        private var targetFunction: WaveFunction?
        
        private var amp:  Float = 1;  private var freq:  Float = 1; private var ph:  Float = 0
        private var tAmp: Float = 1;  private var tFreq: Float = 2; private var tPh: Float = 0

        private var userColor:   PlatformColor = .blue
        private var targetColor: PlatformColor = .white
        private var isAligning = false
        private var alignProgress: Float = 0.0
        private var progress: Float = 1.0
        private var animationSpeed: Float = 1.0
        
        private var waveOpacity: Float = 1.0
        private var waveGlowIntensity: Float = 0.0
        
        private var gridColor: PlatformColor = .gray
        private var gridOpacity: Float = 0.3
        private var gridLineCount: Int = 12
        
        private var dropLineColor: PlatformColor = .gray
        private var dropLineOpacity: Float = 0.3
        private var dropLineCount: Int = 30
        
        private var cameraAngle: WaveCameraConfig = .iso

        private let gridY: Float = -2.2

        func setup(userWaveNode: SCNNode, targetWaveNode: SCNNode, dropLineNode: SCNNode, gridNode: SCNNode, cameraNode: SCNNode,
                   userColor: PlatformColor, targetColor: PlatformColor) {
            self.userWaveNode   = userWaveNode
            self.targetWaveNode = targetWaveNode
            self.dropLineNode   = dropLineNode
            self.gridNode       = gridNode
            self.cameraNode     = cameraNode
            self.userColor      = userColor
            self.targetColor    = targetColor
        }

        func updateParams(function: WaveFunction, targetFunction: WaveFunction?,
                          amp: Float, freq: Float, ph: Float,
                          tAmp: Float, tFreq: Float, tPh: Float,
                          userColor: PlatformColor, targetColor: PlatformColor,
                          isAligning: Bool,
                          progress: Float, animationSpeed: Float,
                          waveOpacity: Float, waveGlowIntensity: Float,
                          gridColor: PlatformColor, gridOpacity: Float, gridLineCount: Int,
                          dropLineColor: PlatformColor, dropLineOpacity: Float, dropLineCount: Int,
                          cameraAngle: WaveCameraConfig) {
            self.function = function
            self.targetFunction = targetFunction
            self.amp  = amp;  self.freq  = freq; self.ph  = ph
            self.tAmp = tAmp; self.tFreq = tFreq; self.tPh = tPh
            self.userColor = userColor
            self.targetColor = targetColor
            self.isAligning = isAligning
            self.progress = progress
            self.animationSpeed = animationSpeed
            self.waveOpacity = waveOpacity
            self.waveGlowIntensity = waveGlowIntensity
            self.gridColor = gridColor
            self.gridOpacity = gridOpacity
            self.gridLineCount = gridLineCount
            self.dropLineColor = dropLineColor
            self.dropLineOpacity = dropLineOpacity
            self.dropLineCount = dropLineCount
            self.cameraAngle = cameraAngle
        }

        func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
            let t = Float(time) * 1.1 * animationSpeed
            
            // Update Camera
            let az = Float(cameraAngle.azimuth) * .pi / 180.0
            let el = Float(cameraAngle.elevation) * .pi / 180.0
            let dist = Float(cameraAngle.distance)
            
            let dy = dist * sin(el)
            let groundDist = dist * cos(el)
            let dx = groundDist * sin(az)
            let dz = groundDist * cos(az)
            
            #if os(macOS)
//            cameraNode?.camera?.fieldOfView = CGFloat(cameraAngle.fov)
            cameraNode?.position = SCNVector3(CGFloat(6.0 + dx), CGFloat(-1.0 + dy), CGFloat(5.0 + dz))
            #else
            cameraNode?.camera?.fieldOfView = CGFloat(cameraAngle.fov)
            cameraNode?.position = SCNVector3(6.0 + dx, -1.0 + dy, 5.0 + dz)
            #endif
            cameraNode?.look(at: SCNVector3(6.0, -1.0, 5.0))
            
            if isAligning {
                alignProgress = min(alignProgress + 0.03, 1.0)
            } else {
                alignProgress = max(alignProgress - 0.03, 0.0)
            }
            
            updateWave(node: userWaveNode, amp: amp, freq: freq, ph: ph, color: userColor, t: t, isTarget: false)
            
            if targetFunction != nil {
                updateWave(node: targetWaveNode, amp: tAmp, freq: tFreq, ph: tPh, color: targetColor, t: t, isTarget: true)
            } else {
                targetWaveNode?.geometry = nil
            }
            
            updateDropLines(t: t)
            
            if gridLineCount > 0 {
                updateGrid()
            } else {
                gridNode?.geometry = nil
            }
        }

        private func updateWave(node: SCNNode?, amp: Float, freq: Float, ph: Float, color: PlatformColor, t: Float, isTarget: Bool) {
            guard let node = node else { return }

            var allVerts: [SCNVector3] = []
            var elements:  [SCNGeometryElement]  = []
            var materials: [SCNMaterial]          = []

            let segCount = 35
            let ptsPerSeg = 8
            
            let zStart: Float = 15.0
            let zEnd: Float = 0.0
            let zStep = (zEnd - zStart) / Float(segCount * ptsPerSeg)
            
            let targetXOffset: Float = mix(9.6, 6.0, alignProgress)
            let userXOffset: Float = mix(2.4, 6.0, alignProgress)
            let xCenter = isTarget ? targetXOffset : userXOffset
            let yOffset: Float = 0
            let ribbonWidth: Float = 4.25

            let activeSegs = max(1, Int(Float(segCount) * progress))
            for s in 0..<activeSegs {
                let distanceFraction = Float(s) / Float(segCount)
                let alphaMultiplier: Float = isTarget ? 0.6 : 0.7
                let alpha = pow(1.0 - distanceFraction, 2.8) * alphaMultiplier
                let attenuation: Float = pow(1.0 - distanceFraction, 1.2)
                
                let mat = SCNMaterial()
                mat.lightingModel = .constant
                mat.blendMode           = .add
                mat.isDoubleSided       = true
                mat.writesToDepthBuffer = false
                
                mat.diffuse.contents = color.withAlphaComponent(CGFloat(alpha * 0.55 * waveOpacity))
                let glowMultiplier: Float = isTarget ? 1.75 : (1.25 + waveGlowIntensity)
                mat.emission.contents = color.withAlphaComponent(CGFloat(alpha * glowMultiplier * waveOpacity))
                
                let base = Int32(allVerts.count)
                var segIdx: [Int32] = []
                
                for i in 0...ptsPerSeg {
                    let globalIdx = s * ptsPerSeg + i
                    let z = zStart + Float(globalIdx) * zStep
                    let y = waveZ(amp: amp * attenuation, freq: freq, ph: ph, z: z, t: t, isTarget: isTarget)
                    
                    allVerts.append(SCNVector3(xCenter - ribbonWidth / 2, y + yOffset, z))
                    allVerts.append(SCNVector3(xCenter + ribbonWidth / 2, y + yOffset, z))
                    
                    let vIdx = base + Int32(i * 2)
                    segIdx.append(vIdx)
                    segIdx.append(vIdx + 1)
                }
                
                let elem = SCNGeometryElement(indices: segIdx, primitiveType: .triangleStrip)
                elements.append(elem)
                materials.append(mat)
            }

            let geo = SCNGeometry(sources: [SCNGeometrySource(vertices: allVerts)],
                                  elements: elements)
            geo.materials = materials
            node.geometry = geo
        }

        private func updateGrid() {
            guard let node = gridNode else { return }

            if gridLineCount <= 0 {
                node.geometry = nil
                return
            }

            let targetXOffset: Float = mix(9.6, 6.0, alignProgress)
            let userXOffset: Float = mix(2.4, 6.0, alignProgress)
            let ribbonWidth: Float = 4.25
            let hasTarget = targetFunction != nil
            
            let minX = userXOffset - (ribbonWidth / 2) - 0.5
            let maxX = hasTarget ? (targetXOffset + (ribbonWidth / 2) + 0.5) : (userXOffset + (ribbonWidth / 2) + 0.5)
            
            let totalW = maxX - minX
            let startX = minX

            let cols  = gridLineCount
            let rows  = Int(Float(gridLineCount) * 1.25)
            let totalD: Float = 15.0
            let cellW: Float = totalW / Float(cols)
            let cellD: Float = totalD / Float(rows)
            
            // Grid draws from Z=15.0 down to currentZMin
            let currentZMin = totalD - (totalD * progress)

            var verts: [SCNVector3] = []
            var idx:   [Int32]      = []

            func seg(_ a: SCNVector3, _ b: SCNVector3) {
                idx.append(Int32(verts.count)); verts.append(a)
                idx.append(Int32(verts.count)); verts.append(b)
            }

            for r in 0...rows {
                let z = Float(r) * cellD
                if z >= currentZMin {
                    seg(SCNVector3(startX, gridY, z), SCNVector3(maxX, gridY, z))
                }
            }
            
            for c in 0...cols {
                let x = startX + Float(c) * cellW
                seg(SCNVector3(x, gridY, totalD), SCNVector3(x, gridY, currentZMin))
            }

            if verts.isEmpty {
                node.geometry = nil
                return
            }

            let geo  = SCNGeometry(sources: [SCNGeometrySource(vertices: verts)],
                                   elements: [SCNGeometryElement(indices: idx, primitiveType: .line)])
            let mat  = SCNMaterial()
            mat.lightingModel       = .constant
            mat.diffuse.contents    = gridColor.withAlphaComponent(CGFloat(gridOpacity))
            mat.emission.contents   = gridColor.withAlphaComponent(CGFloat(gridOpacity * 0.5))
            mat.blendMode           = .add
            mat.writesToDepthBuffer = false
            geo.materials = [mat]

            node.geometry = geo
        }

        private func updateDropLines(t: Float) {
            guard let node = dropLineNode else { return }

            if dropLineCount <= 0 {
                node.geometry = nil
                return
            }
            
            var allVerts: [SCNVector3] = []
            var elements: [SCNGeometryElement] = []
            var materials: [SCNMaterial] = []
            
            let segCount = 260
            let interval = max(1, segCount / dropLineCount)
            let zStart: Float = 15.0
            let zEnd: Float = 0.0
            let zStep = (zEnd - zStart) / Float(segCount)
            
            func generateLines(amp: Float, freq: Float, ph: Float, isTarget: Bool, color: PlatformColor) {
                let targetXOffset: Float = mix(9.6, 6.0, alignProgress)
                let userXOffset: Float = mix(2.4, 6.0, alignProgress)
                let xCenter = isTarget ? targetXOffset : userXOffset
                
                let ribbonWidth: Float = 4.25
                let rowCount = 5
                let rowStep = ribbonWidth / Float(rowCount - 1)
                let startX = xCenter - (ribbonWidth / 2)
                
                var idx: [Int32] = []

                let activeSegs = max(1, Int(Float(segCount) * progress))
                for s in stride(from: 0, to: activeSegs, by: interval) {
                    let distanceFraction = Float(s) / Float(segCount)
                    let attenuation: Float = pow(1.0 - distanceFraction, 1.2)
                    let z = zStart + Float(s) * zStep
                    let y = waveZ(amp: amp * attenuation, freq: freq, ph: ph, z: z, t: t, isTarget: isTarget)
                    
                    for r in 0..<rowCount {
                        let lineX = startX + Float(r) * rowStep
                        idx.append(Int32(allVerts.count)); allVerts.append(SCNVector3(lineX, y, z))
                        idx.append(Int32(allVerts.count)); allVerts.append(SCNVector3(lineX, gridY, z))
                    }
                }
                
                let elem = SCNGeometryElement(indices: idx, primitiveType: .line)
                elements.append(elem)

                let mat = SCNMaterial()
                mat.lightingModel       = .constant
                let glowMult: Float = isTarget ? 1.2 : 0.8
                mat.diffuse.contents    = color.withAlphaComponent(CGFloat(dropLineOpacity * 0.5 * glowMult))
                mat.emission.contents   = color.withAlphaComponent(CGFloat(dropLineOpacity * 0.3 * glowMult))
                mat.blendMode           = .add
                mat.writesToDepthBuffer = false
                materials.append(mat)
            }
            
            generateLines(amp: self.amp, freq: self.freq, ph: self.ph, isTarget: false, color: self.dropLineColor)
            
            if self.targetFunction != nil {
                generateLines(amp: self.tAmp, freq: self.tFreq, ph: self.tPh, isTarget: true, color: self.targetColor)
            }

            let geo = SCNGeometry(sources: [SCNGeometrySource(vertices: allVerts)],
                                  elements: elements)
            geo.materials = materials
            node.geometry = geo
        }

        private func mix(_ a: Float, _ b: Float, _ t: Float) -> Float {
            return a + (b - a) * t
        }

        private func waveZ(amp: Float, freq: Float, ph: Float, z: Float, t: Float, isTarget: Bool) -> Float {
            let fn = isTarget ? (targetFunction ?? function) : function
            
            // Standard Swift UI mappings:
            // Input = frequency * x + phase.
            // z * 1.5 fits it on the 3D grid appropriately.
            let input = Double(freq) * Double(z) * 1.5 + Double(ph) + Double(t) * 4.0
            let rawY = fn.evaluate(input)
            return Float(rawY) * amp
        }
    }
}

#if os(macOS)
public enum NavigationBarItem {
    public enum TitleDisplayMode {
        case inline
        case large
        case automatic
    }
}
extension View {
    public func navigationBarTitleDisplayMode(_ displayMode: NavigationBarItem.TitleDisplayMode) -> some View {
        self
    }
}
#endif
