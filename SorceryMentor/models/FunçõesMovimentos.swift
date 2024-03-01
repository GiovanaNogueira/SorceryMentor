//
//  FunçõesMovimentos.swift
//  SorceryMentor
//
//  Created by Giovana Nogueira on 29/02/24.
//

import CoreMotion
import SwiftUI
import AVFoundation
import SpriteKit
import ARKit
import SceneKit
import AudioToolbox

//TODO: consertar a luz - desligar quando sair
class MotionDetectorLumos: ObservableObject {
    private var motionManager = CMMotionManager()
    private let queue = OperationQueue()
    private var lastMagnitude: Double = 0

    var accelerationThreshold: Double = 2.0 // Ajustado para movimentos leves
    var accelerationVariationThreshold: Double = 0.3 // Ajustado para variações menores

    init() {
        startMonitoring()
    }

    func startMonitoring() {
        guard motionManager.isAccelerometerAvailable else { return }
        
        motionManager.accelerometerUpdateInterval = 1 / 60
        motionManager.startAccelerometerUpdates(to: queue) { [weak self] (data, error) in
            guard let strongSelf = self, let data = data else { return }
            
            let acceleration = data.acceleration
            let magnitude = sqrt(acceleration.x * acceleration.x + acceleration.y * acceleration.y + acceleration.z * acceleration.z)
            let variation = abs(magnitude - strongSelf.lastMagnitude)
            
            if magnitude > strongSelf.accelerationThreshold && variation > strongSelf.accelerationVariationThreshold {
                DispatchQueue.main.async {
                    strongSelf.toggleFlashlight()
                }
            }
            
            strongSelf.lastMagnitude = magnitude
        }
    }
    
    func toggleFlashlight() {
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else { return }
        try? device.lockForConfiguration()
        
        if device.torchMode == .off {
            try? device.setTorchModeOn(level: AVCaptureDevice.maxAvailableTorchLevel)
        } else {
            device.torchMode = .off
        }
        
        device.unlockForConfiguration()
    }
}

class MotionDetectorExpelliarmus: ObservableObject {
    private var motionManager = CMMotionManager()
    private let queue = OperationQueue()
    private var lastYAcceleration: Double = 0
    @Published var movementDetected = false

    var movementThreshold: Double = 1.5// Sensibilidade do movimento

    init() {
        startMonitoring()
    }

    func startMonitoring() {
        guard motionManager.isAccelerometerAvailable else { return }
        
        motionManager.accelerometerUpdateInterval = 1 / 60
        motionManager.startAccelerometerUpdates(to: queue) { [weak self] (data, error) in
            guard let strongSelf = self, let data = data else { return }
            
            let yAcceleration = data.acceleration.y
            let variation = yAcceleration - strongSelf.lastYAcceleration
            
            //print(yAcceleration)
            //print(variation)
            
            // Detecta um movimento brusco para cima e para baixo
            if !strongSelf.movementDetected && abs(variation) > strongSelf.movementThreshold {
                DispatchQueue.main.async {
                    strongSelf.movementDetected = true
                    strongSelf.triggerVibration()
                    // Reset depois de um curto delay para evitar múltiplas detecções
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        strongSelf.movementDetected = false
                    }
                }
            }
            
            strongSelf.lastYAcceleration = yAcceleration
        }
    }
    
    func triggerVibration() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate) // Vibra o dispositivo
    }
}

class ModelViewModel: ObservableObject {
    @Published var isModelVisible = false
    private var motionManager = CMMotionManager()
    
    // Novos limiares e variáveis para detectar um "movimento de varinha"
    private let gestureThreshold: Double = 1.0 // Ajuste baseado na experimentação
    private var gestureDetected = false

    init() {
        startMonitoringDeviceMovement()
    }

    private func startMonitoringDeviceMovement() {
        guard motionManager.isDeviceMotionAvailable else { return }
        
        motionManager.deviceMotionUpdateInterval = 0.05 // Aumentar a frequência para capturar o gesto rapidamente
        
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] (motion, error) in
            guard let strongSelf = self, let motion = motion, error == nil else {
                print("Erro ao acessar os dados de movimento do dispositivo: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            // Analisa aceleração nos eixos x e y para detectar um movimento rápido em qualquer direção
            let xAcceleration = motion.userAcceleration.x
            let yAcceleration = motion.userAcceleration.y
            
            // Calcula a magnitude da aceleração
            let accelerationMagnitude = sqrt(pow(xAcceleration, 2) + pow(yAcceleration, 2))
            
            // Verifica se a magnitude da aceleração excede o limiar definido
            if accelerationMagnitude > strongSelf.gestureThreshold {
                if !strongSelf.gestureDetected {
                    DispatchQueue.main.async {
                        strongSelf.isModelVisible = true
                        strongSelf.gestureDetected = true
                        
                        // Opção para ocultar o modelo automaticamente após um curto período
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            strongSelf.isModelVisible = false
                            strongSelf.gestureDetected = false // Reset para permitir novos gestos
                        }
                    }
                }
            }
        }
    }
}


struct ARViewContainer: UIViewRepresentable {
    @ObservedObject var viewModel: ModelViewModel
    var modelNode: SCNNode?

    init(viewModel: ModelViewModel) {
        self.viewModel = viewModel
        if let model3D = SCNScene(named: "Patronus.usdz"), let modelScene = model3D.rootNode.childNodes.first {
            let modelNode = SCNNode()
            modelNode.addChildNode(modelScene)
            modelNode.position = SCNVector3(x: 20.0, y: -70.0, z: -70.0) // Ajuste conforme necessário
            self.modelNode = modelNode
        }
    }

    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView()
        let configuration = ARWorldTrackingConfiguration()
        arView.session.run(configuration)
        return arView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {
        if viewModel.isModelVisible {
            if let modelNode = modelNode, modelNode.parent == nil {
                uiView.scene.rootNode.addChildNode(modelNode)
            }
        } else {
            modelNode?.removeFromParentNode()
        }
    }
}

