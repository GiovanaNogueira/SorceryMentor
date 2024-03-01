//
//  Visuais.swift
//  SorceryMentor
//
//  Created by Giovana Nogueira on 29/02/24.
//

import CoreMotion
import SwiftUI
import AVFoundation
import SpriteKit

struct Sparkle: View {
    var body: some View {
        Circle()
            .fill(Color.yellow)
            .opacity(0.5)
            .frame(width: 10, height: 10)
            .scaleEffect(0.5)
            .animation(Animation.easeOut(duration: 0.5).repeatForever(autoreverses: false))
    }
}

extension View {
    func tamanhoDinamico(sizeCategory: ContentSizeCategory, baseSize: CGFloat, scaleFactor: CGFloat = 1.25) -> CGFloat {
        switch sizeCategory {
        case .extraSmall:
            return baseSize * scaleFactor * 0.75
        case .small:
            return baseSize * scaleFactor * 0.875
        case .medium:
            return baseSize * scaleFactor
        case .large:
            return baseSize * scaleFactor * 1.125
        case .extraLarge:
            return baseSize * scaleFactor * 1.25
        case .extraExtraLarge:
            return baseSize * scaleFactor * 1.5
        case .extraExtraExtraLarge:
            return baseSize * scaleFactor * 1.75
        default:
            return baseSize * scaleFactor * 2.0
        }
    }
}

struct EstiloFeiticos: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
            configuration.label
            .foregroundStyle(.white)
            .padding(.vertical, 2)
            .padding(.horizontal, 10)
            .background(.brown, in: RoundedRectangle(cornerRadius: 3))
            //.scaleEffect(configuration.isPressed ? 1.1 : 1.0)
            .opacity(configuration.isPressed ? 0.5 : 1.0)
            .multilineTextAlignment(.center)
            //.animation(.easeOut, value: configuration.isPressed)
        }}
