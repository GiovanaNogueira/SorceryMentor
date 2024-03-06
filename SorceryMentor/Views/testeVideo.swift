////
////  testeVideo.swift
////  SorceryMentor
////
////  Created by Giovana Nogueira on 06/03/24.
////
//
//import SwiftUI
//
//struct VideoView: View {
//    @Environment(\.dismiss) var dismiss
//    var videoToPlay: String
//    
//    var body: some View {
//        ZStack {
//            GeometryReader { geo in
//                PlayerView(videoName: videoToPlay)
//                    .frame(width: geo.size.width, height: geo.size.height)
//            }
//            
//            VStack {
//                Spacer()
//                HStack {
//                    Spacer()
//                    Button(action: {
//                        dismiss()
//                    }) {
//                        Image("buttonBACK")
//                            .resizable()
//                            .frame(width: 70, height: 70) // Ajustando o tamanho do botão de voltar
//                    }
//                    .padding()
//                    Spacer()
//                    
//                    NavigationLink(destination: ThirdView(videoToPlay: videoToPlay)) {
//                        Image("buttonGO")
//                            .resizable()
//                            .frame(width: 70, height: 70) // Ajustando o tamanho do botão de navegação
//                    }
//                    .padding()
//                    
//                    Spacer()
//                }
//                Text(" ")
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .ignoresSafeArea()
//        }
//    }
//}
//
//#Preview {
//    VideoView(dismiss: <#T##arg#>, videoToPlay: <#T##String#>)
//}
