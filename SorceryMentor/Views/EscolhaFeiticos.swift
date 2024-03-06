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
import AVKit


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
    @StateObject var speechToText = SpeechToText(language: "en-US")


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
            Movimento2View( speechToText: speechToText, mudarTelaParaDetalhes: {telaAtual = .detalhe})
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
        
        Image("Fundo")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
        VStack{
                
        
            Text("Welcome Wizards to")
                .font(.custom("Moshinta", size: tamanhoDinamico(sizeCategory: sizeCategory, baseSize: 16)))
                .foregroundColor(.white)
            
            Text("sorcery")
                .font(.custom("WizardWorld-Simplified", size: tamanhoDinamico(sizeCategory: sizeCategory, baseSize: 30)))
                .multilineTextAlignment(.center)
                .padding(.top, 1)
                .foregroundColor(.white)
            
            Text("mentor")
                .font(.custom("WizardWorld-Simplified", size: tamanhoDinamico(sizeCategory: sizeCategory, baseSize: 30)))
                .multilineTextAlignment(.center)
                .padding(.bottom, 50)
                .foregroundColor(.white)
            
            Image("logoHogwarts")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
                    .padding(.bottom, 70)

            
        }.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()/* + 3*/) {
                mudarTelaParaDetalhes()
            }
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
            Image("Fundo2")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                HStack{
                    Text("escolha UM\nfeitiço")
                        .font(.custom("WizardWorld-Simplified", size: tamanhoDinamico(sizeCategory: sizeCategory, baseSize: 30)))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)

                }
                .padding(.bottom, 70)
                Button(action: {
                    indFeitico = 0
                    telaAtual = .treinomovimento1
                }, label: {
                    HStack {
                        
                        Text("lumos")
                            .font(.custom("WizardWorld-Simplified", size: tamanhoDinamico(sizeCategory: sizeCategory, baseSize: 20)))
                            .foregroundColor(.white)
                            .frame(width:311.6, height: 67)
                    }
                })
                .cornerRadius(10)
//                .opacity(fade ? 0.4 : 1.0)
//                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: fade)
//                .onAppear {
//                    fade = true
//                }
                .padding(.bottom, 40)
                .offset(x: 0 , y: move ? 2 : -2)
                            .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: move)
                            .onAppear {
                                move = true
                            }

                Button( action: {
                    indFeitico = 1
                    telaAtual = .feitiço2
                }, label: {
                    HStack {
                        
                        Text("expelliarmus")
                            .font(.custom("WizardWorld-Simplified", size: tamanhoDinamico(sizeCategory: sizeCategory, baseSize: 20)))
                            .foregroundColor(.white)
                            .frame(width:311.6, height: 67)
//                            .background(
//                                RoundedRectangle(cornerRadius: 10)
//                                    .fill(Color(red: 197 / 255, green: 172 / 255, blue: 1 / 255))
//                            )
                    }
                })
                .cornerRadius(10)
//                .scaleEffect(pulsate ? 1.04 : 1.0)
//                .onAppear {withAnimation(.easeInOut(duration: 0.7).repeatForever(autoreverses: true)) {
//                    pulsate.toggle()}}
                .padding(.bottom, 40)
                .offset(x: 0 , y: move ? 2 : -2)
                            .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: move)
                            .onAppear {
                                move = true
                            }
                
                Button(action:{
                    indFeitico = 2
                    telaAtual = .feitiço3
                }, label: {
                    HStack {
                        Text("expectro\npatronum")
                            .font(.custom("WizardWorld-Simplified", size: tamanhoDinamico(sizeCategory: sizeCategory, baseSize: 20)))
                            .foregroundColor(.white)
                            .frame(width:311.6, height: 67)
                        
                    }
                })
                .cornerRadius(10)
                .offset(x: 0 , y: move ? 2 : -2)
                            .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: move)
                            .onAppear {
                                move = true
                            }
            }.buttonStyle(EstiloFeiticos())
                .padding(.bottom, 100)
            
        }
    }
}

struct Feitico1View: View {
    // Estado para controlar a imagem atual
    @State private var currentIndex = 0
    // Estado para controlar a opacidade durante a transição
    @State private var opacity = 1.0
    @Environment(\.sizeCategory) var sizeCategory
   
    
    var mudarParaAudio1: () -> Void
    var mudarTelaParaDetalhes: () -> Void
    
    var body: some View {
        
        ZStack{
//            Image("Fundo2")
//                .resizable()
//                .scaledToFill()
//                .ignoresSafeArea()
            VStack{
    
                Text("lumos").font(.custom("WizardWorld-Simplified", size: tamanhoDinamico(sizeCategory: sizeCategory, baseSize: 30)))
                    .foregroundColor(.white)
                    .padding(.bottom, 50)
//                    .frame(width:311.6, height: 67)
                
                Text("""
                     É um feitiço usado para conjurar um feixe de luz na ponta da varinha. Além de iluminar, esse feitiço também pode repelir inimigos espectrais, como espíritos malignos.
                    """)
                    .multilineTextAlignment(.center)
                    .font(.custom("DejaVuSerif-Bold", size: tamanhoDinamico(sizeCategory: sizeCategory, baseSize: 16)))
                    .padding(.horizontal, 35)
                    .padding(.bottom, 60)
                    .foregroundColor(.white)
                
                Button(action: mudarParaAudio1, label: {
                    Text("IR PARA TREINO DE VOZ")
                        .padding(.horizontal, 20)
                        .padding(.vertical, 15)
                })
                .padding(10)
                .font(.custom("DejaVuSerif-Bold", size: tamanhoDinamico(sizeCategory: sizeCategory, baseSize: 11)))
                .foregroundColor(.white)
                .buttonStyle(EstiloFeiticos())
  
                
                Button("VOLTAR PARA FEITIÇOS", action: mudarTelaParaDetalhes)
                    .foregroundColor(.white)
                    .font(.custom("DejaVuSerif-Bold", size: tamanhoDinamico(sizeCategory: sizeCategory, baseSize: 11)))
                    .padding(.bottom, 50)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Image("Fundo2")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
    }
}


struct Feitico2View: View {
    @Environment(\.sizeCategory) var sizeCategory
    
    var mudarParaAudio2: () -> Void
    var mudarTelaParaDetalhes: () -> Void

    var body: some View {
        ZStack{
            Image("Fundo2")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack{
                Text("expelliarmus").font(.custom("WizardWorld-Simplified", size: tamanhoDinamico(sizeCategory: sizeCategory, baseSize: 30)))
                    .foregroundColor(.white)
                    .padding(.bottom, 50)
                
                Text("É um feitiço de desarme. Usado em duelos para fazer o adversário perder sua varinha.")
                    .multilineTextAlignment(.center)
                    .font(.custom("DejaVuSerif-Bold", size: tamanhoDinamico(sizeCategory: sizeCategory, baseSize: 16)))
                    .foregroundColor(.white)
                    .padding(.horizontal, 35)
                    .padding(.bottom, 60)
                
                Button(action: mudarParaAudio2, label: {
                    Text("IR PARA TREINO DE VOZ")
                        .padding(.horizontal, 20)
                        .padding(.vertical, 15)
                })
                .padding(10)
                .font(.custom("DejaVuSerif-Bold", size: tamanhoDinamico(sizeCategory: sizeCategory, baseSize: 11)))
                .foregroundColor(.white)
                .buttonStyle(EstiloFeiticos())
                
                Button("VOLTAR PARA FEITIÇOS", action: mudarTelaParaDetalhes)
                    .foregroundColor(.brown)
                    .font(.custom("DejaVuSerif-Bold", size: tamanhoDinamico(sizeCategory: sizeCategory, baseSize: 11)))
                    .padding(.bottom, 50)
            }
        }
    }
}

struct Feitico3View: View {
    @Environment(\.sizeCategory) var sizeCategory

    var mudarParaAudio3: () -> Void
    var mudarTelaParaDetalhes: () -> Void

    var body: some View {
        ZStack{
            Image("Fundo2")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack{
                Text("expecto patronum").font(.custom("WizardWorld-Simplified", size: tamanhoDinamico(sizeCategory: sizeCategory, baseSize: 30)))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.bottom, 50)
                
                Text("É um feitiço defensivo que conjura um patrono, sendo diferente para cada bruxo. É a única defesa conhecida contra dementadores. ")
                    .multilineTextAlignment(.center)
                    .font(.custom("DejaVuSerif-Bold", size: tamanhoDinamico(sizeCategory: sizeCategory, baseSize: 16)))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.bottom, 60)
                
                Button(action: mudarParaAudio3, label: {
                    Text("IR PARA TREINO DE VOZ")
                        .padding(.horizontal, 20)
                        .padding(.vertical, 15)
                })
                .padding(10)
                .font(.custom("DejaVuSerif-Bold", size: tamanhoDinamico(sizeCategory: sizeCategory, baseSize: 11)))
                .foregroundColor(.white)
                .buttonStyle(EstiloFeiticos())
                
                Button("VOLTAR PARA FEITIÇOS", action: mudarTelaParaDetalhes)
                    .foregroundColor(.brown)
                    .font(.custom("DejaVuSerif-Bold", size: tamanhoDinamico(sizeCategory: sizeCategory, baseSize: 11)))
                    .padding(.bottom, 50)
            }
        }
    }
}

struct TreinoMovimento1View: View{
    @Environment(\.sizeCategory) var sizeCategory
    @ObservedObject var motionDetector = MotionDetectorLumos()
    var mudarTelaParaDetalhes: () -> Void
    var mudarTelaParaMovimento1: () -> Void
    let player = AVPlayer(url: Bundle.main.url(forResource: "IMG_0036", withExtension: "mp4")!)
    
    var body: some View{
        ZStack{
            Image("Fundo2")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VideoPlayer(player: player)
            
//            GeometryReader { geo in
////                PlayerView(videoName: "IMG_0036")
//                    .frame(width: geo.size.width, height: geo.size.height)
//            }
            
            Text("repita o movimento")
                .multilineTextAlignment(.center)
                .font(.custom("WizardWorld-Simplified", size: tamanhoDinamico(sizeCategory: sizeCategory, baseSize: 16)))
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.bottom, 60)
            
            Button(action: mudarTelaParaMovimento1, label: {
                Text("Começar")
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
            })
            .padding(10)
            .font(.custom("WizardWorld-Simplified", size: tamanhoDinamico(sizeCategory: sizeCategory, baseSize: 11)))
            .foregroundColor(.white)
            .buttonStyle(EstiloFeiticos())
            
//            Button("Voltar para feitiços", action: mudarTelaParaDetalhes)
//                .foregroundColor(.brown)
//                .font(.custom("DejaVuSerif-Bold", size: tamanhoDinamico(sizeCategory: sizeCategory, baseSize: 11)))
            
            Button ( action:
                mudarTelaParaDetalhes
            , label: {
                Label("Voltar", systemImage: "chevron.backward")
                    .bold()
            })
            .tint(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding()
        }
    }
}

struct TreinoMovimento2View: View{
    @Environment(\.sizeCategory) var sizeCategory
    @StateObject private var motionDetector = MotionDetectorExpelliarmus()
    var mudarTelaParaDetalhes: () -> Void
    var mudarTelaParaMovimento2: () -> Void
    let player = AVPlayer(url: Bundle.main.url(forResource: "IMG_0037", withExtension: "mp4")!)
    
    var body: some View{
        ZStack{
            Image("Fundo2")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VideoPlayer(player: player)
            
            Text("repita o movimento")
                .multilineTextAlignment(.center)
                .font(.custom("WizardWorld-Simplified", size: tamanhoDinamico(sizeCategory: sizeCategory, baseSize: 16)))
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.bottom, 60)
            
            Button(action: mudarTelaParaMovimento2, label: {
                Text("Começar")
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
            })
            .padding(10)
            .font(.custom("WizardWorld-Simplified", size: tamanhoDinamico(sizeCategory: sizeCategory, baseSize: 11)))
            .foregroundColor(.white)
            .buttonStyle(EstiloFeiticos())
            
//            Button("Voltar para feitiços", action: mudarTelaParaDetalhes)
//                .foregroundColor(.brown)
//                .font(.custom("DejaVuSerif-Bold", size: tamanhoDinamico(sizeCategory: sizeCategory, baseSize: 11)))
            
            Button ( action:
                mudarTelaParaDetalhes
            , label: {
                Label("Voltar", systemImage: "chevron.backward")
                    .bold()
            })
            .tint(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding()
        }
    }
}

struct TreinoMovimento3View: View{
    @Environment(\.sizeCategory) var sizeCategory
    var mudarTelaParaDetalhes: () -> Void
    var mudarTelaParaMovimento3: () -> Void
    let player = AVPlayer(url: Bundle.main.url(forResource: "IMG_0038", withExtension: "mp4")!)
    
    var body: some View{
        ZStack{
            Image("Fundo2")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VideoPlayer(player: player)
            
            Text("repita o movimento")
                .multilineTextAlignment(.center)
                .font(.custom("WizardWorld-Simplified", size: tamanhoDinamico(sizeCategory: sizeCategory, baseSize: 16)))
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.bottom, 60)
            
            Button(action: mudarTelaParaMovimento3, label: {
                Text("Começar")
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
            })
            .padding(10)
            .font(.custom("WizardWorld-Simplified", size: tamanhoDinamico(sizeCategory: sizeCategory, baseSize: 11)))
            .foregroundColor(.white)
            .buttonStyle(EstiloFeiticos())
            
//            Button("Voltar para feitiços", action: mudarTelaParaDetalhes)
//                .foregroundColor(.brown)
//                .font(.custom("DejaVuSerif-Bold", size: tamanhoDinamico(sizeCategory: sizeCategory, baseSize: 11)))
            
            Button ( action:
                mudarTelaParaDetalhes
            , label: {
                Label("Voltar", systemImage: "chevron.backward")
                    .bold()
            })
            .tint(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding()
        }
    }
}


struct Movimento1View: View{
    @Environment(\.sizeCategory) var sizeCategory
    @ObservedObject var motionDetector = MotionDetectorLumos()
    var mudarTelaParaDetalhes: () -> Void
    let totalImages = 13
    @State private var currentImageIndex = 1
    @State private var timer = Timer.publish(every: 0.3, on: .main, in: .common).autoconnect()
    
    var body: some View{
        ZStack{
//            Image("Fundo2")
//                .resizable()
//                .scaledToFill()
//                .ignoresSafeArea()
            Text ("Mexa o celular em movimento circular")
        
            Image("Varinha \(currentImageIndex)")
                .resizable()
                .scaledToFit()
                .frame(width: 1000, height: 1000)
                    .padding(.trailing, 200)
                    .onReceive(timer) { _ in
                        withAnimation {
                            currentImageIndex = currentImageIndex % totalImages + 1
                        }
                    }
            
            
            Button ( action:
                mudarTelaParaDetalhes
            , label: {
                Label("Voltar", systemImage: "chevron.backward")
                    .bold()
            })
            .tint(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Image("Fundo2")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
    }
}

struct Movimento2View: View{
    @Environment(\.sizeCategory) var sizeCategory
    @StateObject private var motionDetector = MotionDetectorExpelliarmus()
    @ObservedObject var speechToText: SpeechToText
    
    let generator = UINotificationFeedbackGenerator()
                
    
    var mudarTelaParaDetalhes: () -> Void
    
    var body: some View{
        ZStack{
//            Image("Fundo2")
//                .resizable()
//                .scaledToFill()
//                .ignoresSafeArea()
            VStack {
                Text ("Movimento 2")
                
                Button ( action:
                    mudarTelaParaDetalhes
                , label: {
                    Label("Voltar", systemImage: "chevron.backward")
                        .bold()
                })
                .tint(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Image("Fundo2")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
        .onChange(of: motionDetector.movementDetected) { oldValue, newValue in
            if newValue{
                print("oi")
                generator.notificationOccurred(.success)
            }
        }.onAppear{
            speechToText.stopTranscribing()
        }
    }
    
}

struct Movimento3View: View{
    @Environment(\.sizeCategory) var sizeCategory
    @StateObject private var viewModel = ModelViewModel()

    var mudarTelaParaDetalhes: () -> Void
    
    var body: some View{
        ZStack{
            Text ("Movimento 3")
            
            ARViewContainer(viewModel: viewModel)
            
            Button ( action:
                mudarTelaParaDetalhes
            , label: {
                Label("Voltar", systemImage: "chevron.backward")
                    .bold()
            })
            .tint(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding()
        }
    }
}


#Preview {
    EscolhaFeiticos()
}

#Preview{
    DetalheView(speechToText: SpeechToText(language: "en-US"), telaAtual: .constant(.audio), indFeitico: .constant(0))
}

