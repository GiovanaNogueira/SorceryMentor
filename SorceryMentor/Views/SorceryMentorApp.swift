//
//  SorceryMentorApp.swift
//  SorceryMentor
//
//  Created by Giovana Nogueira on 26/02/24.
//

import SwiftUI

@main
struct SorceryMentorApp: App {
    
    @State private var indFeitico: Int = 0
    
//    init(){
//        for familyName in UIFont.familyNames{
//            print (familyName)
//            
//            for fontName in
//                    UIFont.fontNames(forFamilyName: familyName){
//                print("--\(fontName)")
//            }
//        }
//    }
    
    var body: some Scene {
        WindowGroup {
            EscolhaFeiticos()
//            ContentView(indFeitico: $indFeitico )
        }
    }
}
