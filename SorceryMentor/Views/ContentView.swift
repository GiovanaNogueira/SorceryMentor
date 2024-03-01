
import SwiftUI

struct ContentView: View {
//    var frase: String = "lumos"
    @Binding var indFeitico:Int
    @Binding var telaAtual: Tela
    @State private var count: Int = 0
    @ObservedObject var speechToText: SpeechToText
    @State private var isCorrect = false

    @State private var isHolding = false
    
    var model = Model()

    var body: some View {
        VStack(spacing: 10) {
            Text("Repita o feitiço:")
                .padding(.top, 50)
            Text(model.feiticos[indFeitico].nome)
            
            Spacer()
            
            Image(systemName: "mic.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .foregroundStyle(isHolding ? .gray : .black)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            guard !isHolding else { return }
                            isHolding = true
//                             count += 1
                            speechToText.startTranscribing()
                        }
                        .onEnded { value in
                            isHolding = false
                            speechToText.stopTranscribing()
                        }
                )
            Spacer()
            HStack{
                Text("Palavras que falamos:")
                ForEach(speechToText.words, id: \.self) { word in
                    Text(word)
                }
            }
        }
        .padding()
        .onChange(of: speechToText.buscadas, { oldValue, newValue in
            isCorrect = newValue.isEmpty
        })

        .onChange(of: speechToText.currentWord) { newCurrentWord in
            if !isCorrect {
                print("Tente novamente: \(newCurrentWord)")
                Text("Tente novamente").foregroundStyle(.red)
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
    }
}

//
//#Preview {
//    ContentView(indFeitico: .constant(0), telaAtual: .constant(.audio), speechToText: <#SpeechToText#>)
//}
