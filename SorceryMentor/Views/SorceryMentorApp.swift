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
    var body: some Scene {
        WindowGroup {
            EscolhaFeiticos()
//            ContentView(indFeitico: $indFeitico )
        }
    }
}
