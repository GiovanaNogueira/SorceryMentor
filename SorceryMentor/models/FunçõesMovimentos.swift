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
    private var movementDetected = false

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
