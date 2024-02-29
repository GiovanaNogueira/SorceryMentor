//
//  EscolhaFeiticos.swift
//  SorceryMentor
//
//  Created by Giovana Nogueira on 28/02/24.
//

import CoreMotion
import SwiftUI
import AVFoundation
import SpriteKit


//Inicio das telas
enum Tela {
    case telaInicial
    case detalhe
    case feitiço1, feitiço2, feitiço3
    case audio
    case treinomovimento1, treinomovimento2, treinomovimento3
    case movimento1, movimento2, movimento3
}

struct EscolhaFeiticos: View {
    @State private var telaAtual: Tela = .telaInicial
    @Environment(\.sizeCategory) var sizeCategory
    @State var indFeitico: Int = 0
    @StateObject private var speechToText = SpeechToText(language: "en-US")


    var body: some View {
        switch telaAtual {
        case .telaInicial:
            TelaInicialView(mudarTelaParaDetalhes: { telaAtual = .detalhe })
        case .detalhe:
            DetalheView(speechToText: speechToText, telaAtual: $telaAtual,
                        indFeitico: $indFeitico)
        case .feitiço1:
            Feitico1View(mudarParaAudio1: { telaAtual = .audio }, mudarTelaParaDetalhes: {telaAtual = .detalhe})
        case .feitiço2:
            Feitico2View(mudarParaAudio2: { telaAtual = .audio }, mudarTelaParaDetalhes: {telaAtual = .detalhe})
        case .feitiço3:
            Feitico3View(mudarParaAudio3: { telaAtual = .audio }, mudarTelaParaDetalhes: {telaAtual = .detalhe})
        case .audio:
            ContentView(indFeitico: $indFeitico, telaAtual: $telaAtual, speechToText: speechToText)
        case .treinomovimento1:
            TreinoMovimento1View(mudarTelaParaDetalhes: {telaAtual = .detalhe}, mudarTelaParaMovimento1: {telaAtual = .movimento1})
        case .treinomovimento2:
            TreinoMovimento2View(mudarTelaParaDetalhes: {telaAtual = .detalhe}, mudarTelaParaMovimento2: {telaAtual = .movimento2})
        case .treinomovimento3:
            TreinoMovimento3View(mudarTelaParaDetalhes: {telaAtual = .detalhe}, mudarTelaParaMovimento3: {telaAtual = .movimento3})
        case .movimento1:
            Movimento1View( mudarTelaParaDetalhes: {telaAtual = .detalhe})
        case .movimento2:
            Movimento2View( mudarTelaParaDetalhes: {telaAtual = .detalhe})
        case .movimento3:
            Movimento3View(mudarTelaParaDetalhes: {telaAtual = .detalhe})
        }
    }
}

struct TelaInicialView: View {
    @Environment(\.sizeCategory) var sizeCategory
    
    var mudarTelaParaDetalhes: () -> Void

    var body: some View {
        ZStack{
        
        Image("Plano de fundo 1")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
            
        VStack{
                
        Image("Logo Hogwarts")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 180)
        
            Text("Welcome Wizards to")
                .font(.custom("Moshinta", size: tamanhoDinamico(sizeCategory: sizeCategory, baseSize: 16)))
            
            Text("RONNY'S")
                .font(.custom("DejaVuSerif", size: tamanhoDinamico(sizeCategory: sizeCategory, baseSize: 24)))
                .multilineTextAlignment(.center)
                .padding(.top, 1)
            
            Text("MOVEMENTS")
                .font(.custom("DejaVuSerif", size: tamanhoDinamico(sizeCategory: sizeCategory, baseSize: 22)))
                .multilineTextAlignment(.center)
                .padding(.bottom, 100)

            
        Button(action: {
            mudarTelaParaDetalhes()
        }) {
            Text("Menu")
                .font(.custom("DejaVuSerif-Bold", size: tamanhoDinamico(sizeCategory: sizeCategory, baseSize: 18)))
                .foregroundStyle(.white)
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .background(.brown, in: RoundedRectangle(cornerRadius: 8))
        }
            
            Spacer()
            
            Image("Ratinho")
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 180)
            
        }
       }
    }
}

struct DetalheView: View {
    
    @Environment(\.sizeCategory) var sizeCategory
    @State private var pulsate = false
    @State private var fade = false
    @State private var move = false
    @State private var touchLocation: CGPoint? = nil
    @State private var showSparkle = false
    
    @ObservedObject var speechToText:SpeechToText
    
    @Binding var telaAtual: Tela
    
    var model = Model()
    
    @Binding var indFeitico: Int
    
    var body: some View {
        ZStack{
            Image("Plano de fundo 1")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                HStack{
                    Text("Feitiços")
                        .font(.custom("DejaVuSerif-Bold", size: tamanhoDinamico(sizeCategory: sizeCategory, baseSize: 20)))
                    
                    Image(systemName: "wand.and.stars")
                        .font(.largeTitle)
                        .foregroundColor(.black)
                }
                
                Button(action: {
                    
                    //                    mudarTelaParaFeitiço1
                    speechToText.mudaFeitico(nomeDoFeiticoNovo: model.feiticos[0].nome)
                    telaAtual = .feitiço1
                    indFeitico = 0
                }, label: {
                    HStack {
                        Image(systemName: "flashlight.off.fill")
                            .font(.largeTitle)
                            .foregroundColor(.yellow)
                            .opacity(fade ? 0.2 : 1.0) // Alterna a opacidade para criar o efeito de fading
                            .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: fade)
                            .onAppear {
                                fade = true
                            }
                        
                        Text("Lumos")
                            .font(.custom("DejaVuSerif-Bold", size: tamanhoDinamico(sizeCategory: sizeCategory, baseSize: 14)))
                            .foregroundColor(.white) // Define a cor do texto
                    }
                })
                .padding()
                //.background(Color.teal)
                .cornerRadius(10)

                Button( action: { speechToText.mudaFeitico(nomeDoFeiticoNovo: model.feiticos[1].nome)
                    telaAtual = .feitiço2
                    indFeitico = 1
                }, label: {
                    HStack {
                        Image(systemName: "lightspectrum.horizontal")
                            .font(.largeTitle)
                            .foregroundColor(.yellow)
                            .scaleEffect(pulsate ? 1.15 : 1.0)
                            .onAppear {withAnimation(.easeInOut(duration: 0.7).repeatForever(autoreverses: true)) {
                                pulsate.toggle()}}
                        
                        Text("Expelliarmus")
                            .font(.custom("DejaVuSerif-Bold", size: tamanhoDinamico(sizeCategory: sizeCategory, baseSize: 14)))
                            .foregroundColor(.white) // Define a cor do texto
                    }
                })
                //.padding()
                .cornerRadius(10)
                
                Button(action:{ speechToText.mudaFeitico(nomeDoFeiticoNovo: model.feiticos[2].nome)
                    telaAtual = .feitiço3
                    indFeitico = 2
                }, label: {
                    HStack {
                        Image(systemName: "dog.fill")
                            .font(.largeTitle)
                            .foregroundColor(.yellow)
                            .offset(x: move ? 4 : -4, y: 0) // Move horizontalmente 20 pontos para cada lado
                                        .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: move)
                                        .onAppear {
                                            move = true
                                        }
                        
                        Text("Expectro Patronum")
                            .font(.custom("DejaVuSerif-Bold", size: tamanhoDinamico(sizeCategory: sizeCategory, baseSize: 14)))
                            .foregroundColor(.white)
                        
                    }
                })
                .padding()
                //.background(Color.teal)
                .cornerRadius(10)
            }.buttonStyle(EstiloFeiticos())
        }
    }
}

struct Feitico1View: View {
    var mudarParaAudio1: () -> Void
    var mudarTelaParaDetalhes: () -> Void
    
    let images = ["imagem1", "imagem2", "imagem3"]
        // Estado para controlar a imagem atual
    @State private var currentIndex = 0
        // Estado para controlar a opacidade durante a transição
    @State private var opacity = 1.0
    
    var body: some View {
        
        ZStack{
            Image(images[currentIndex])
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                        .opacity(opacity)
                        .onAppear {
                            Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
                                withAnimation(.easeInOut(duration: 1.5)) {
                                    // Anima a redução da opacidade para 0
                                    self.opacity = 0.5
                                }
                                // Após a animação de fade out, atualiza a imagem e restaura a opacidade
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    currentIndex = (currentIndex + 1) % images.count
                                    withAnimation(.easeInOut(duration: 2.0)) {
                                        // Anima o retorno da opacidade para 1
                                        self.opacity = 1.0
                                    }
                                }
                            }
                        }
            VStack{
                Text("Descrição do feitiço")
                //Text("Descrição do feitiço")
                Button("Ir para o treino de voz", action: mudarParaAudio1)
                
                Button("Voltar para feitiços", action: mudarTelaParaDetalhes)
            }
        }
        }
    }


struct Feitico2View: View {
    var mudarParaAudio2: () -> Void
    var mudarTelaParaDetalhes: () -> Void

    var body: some View {
        ZStack{
            Image("Plano de fundo 1")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack{
                Text("Descrição do feitiço")
                Button("Ir para o treino de voz", action: mudarParaAudio2)
                
                Button("Voltar para feitiços", action: mudarTelaParaDetalhes)
            }
        }
    }
}

struct Feitico3View: View {
    var mudarParaAudio3: () -> Void
    var mudarTelaParaDetalhes: () -> Void

    var body: some View {
        ZStack{
            Image("Plano de fundo 1")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack{
                Text("Descrição do feitiço")
                Button("Ir para o treino de voz", action: mudarParaAudio3)

                Button("Voltar para feitiços", action: mudarTelaParaDetalhes)
            }
        }
    }
}

struct TreinoMovimento1View: View{
    @ObservedObject var motionDetector = MotionDetectorLumos()
    var mudarTelaParaDetalhes: () -> Void
    var mudarTelaParaMovimento1: () -> Void
    
    var body: some View{
        Text ("Treino do movimento 1")
        Button("Ir para movimento 1", action: mudarTelaParaMovimento1)
        Button("Voltar para feitiços", action: mudarTelaParaDetalhes)
    }
}

struct TreinoMovimento2View: View{
    @StateObject private var motionDetector = MotionDetectorExpelliarmus()
    var mudarTelaParaDetalhes: () -> Void
    var mudarTelaParaMovimento2: () -> Void
    
    var body: some View{
        Text ("Treino do movimento 2")
        Button("Ir para movimento 2", action: mudarTelaParaMovimento2)
        Button("Voltar para feitiços", action: mudarTelaParaDetalhes)
    }
}

struct TreinoMovimento3View: View{
    var mudarTelaParaDetalhes: () -> Void
    var mudarTelaParaMovimento3: () -> Void
    
    var body: some View{
        Text ("Treino do movimento 3")
        Button("Ir para movimento 3", action: mudarTelaParaMovimento3)
        Button("Voltar para feitiços", action: mudarTelaParaDetalhes)
    }
}


struct Movimento1View: View{
    @ObservedObject var motionDetector = MotionDetectorLumos()
    var mudarTelaParaDetalhes: () -> Void
    
    var body: some View{
    Text ("Mexa o celular em movimento circular")
        
        Button("Voltar para feitiços", action: mudarTelaParaDetalhes)
    }
}

struct Movimento2View: View{
    @StateObject private var motionDetector = MotionDetectorExpelliarmus()
    var mudarTelaParaDetalhes: () -> Void
    
    var body: some View{
    Text ("Movimento 2")
        
        Button("Voltar para feitiços", action: mudarTelaParaDetalhes)
    }
}

struct Movimento3View: View{
    var mudarTelaParaDetalhes: () -> Void
    
    var body: some View{
    Text ("Movimento 3")
        
        Button("Voltar para feitiços", action: mudarTelaParaDetalhes)
    }
}


#Preview {
    EscolhaFeiticos()
}

#Preview{
    DetalheView(speechToText: SpeechToText(language: "en-US"), telaAtual: .constant(.audio), indFeitico: .constant(0))
}
