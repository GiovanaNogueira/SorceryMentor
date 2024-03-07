
import SwiftUI

struct ContentView: View {
    @Binding var indFeitico:Int
    @Binding var telaAtual: Tela
    @State private var count: Int = 0
    @ObservedObject var speechToText: SpeechToText
    @State private var isCorrect = false
    
    @State var isShowingTryAgain = false
    @Environment(\.sizeCategory) var sizeCategory
    @State private var isHolding = false
    
    var model = Model()

    var body: some View {
        
        ZStack{
            
            VStack(spacing: 10) {
                Text("Repita o feitiço:")
                    .padding(.top, 100)
                    .font(.custom("DejaVuSerif-Bold", size: tamanhoDinamico(sizeCategory: sizeCategory, baseSize: 16)))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.bottom, 20)
                
                Text("\"\(model.feiticos[indFeitico].nome)\"")
                    .font(.custom("DejaVuSerif-Bold", size: tamanhoDinamico(sizeCategory: sizeCategory, baseSize: 16)))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                
                Spacer()
                
                Image(systemName: "mic.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .foregroundStyle(isHolding ? .gray : .white)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                guard !isHolding else { return }
                                isHolding = true
                                //                             count += 1
                                speechToText.startTranscribing()
                                isShowingTryAgain = false
                            }
                            .onEnded { value in
                                speechToText.stopTranscribing()
                                isHolding = false
                            }
                    )
                Spacer()
                
                if isShowingTryAgain{
                    Text("Tente novamente").foregroundStyle(.white)
                        .padding(.bottom, 200)
                }
                
            }
            .padding()
            .onAppear{
                speechToText.mudaFeitico(nomeDoFeiticoNovo: model.feiticos[indFeitico].nome)
            }
            .onChange(of: speechToText.words, {
                if speechToText.confere(){
                    speechToText.stopTranscribing()
                    isCorrect = true
                }
            })
            
            .onChange(of: speechToText.currentWord) {newCurrentWord in
                if !isCorrect{
                    isShowingTryAgain = true
                }
            }
            
            .onChange(of: isCorrect) { newValue in
                if newValue {
                    switch indFeitico {
                    case 0:
                        telaAtual = .treinomovimento1
                    case 1:
                        telaAtual = .treinomovimento2
                    case 2:
                        telaAtual = .treinomovimento3
                    default:
                        break
                    }
                }
            }
            Button {
                telaAtual = .detalhe
            } label: {
                Label("Voltar", systemImage: "chevron.backward")
                    .bold()
            }
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
