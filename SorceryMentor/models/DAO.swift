//
//  DAO.swift
//  SorceryMentor
//
//  Created by Giovana Nogueira on 28/02/24.
//

import Foundation

//enum Feiticos{
//    case lumos, expectoPratono, expeliarmos
//}

struct Feitico {
    var nome: String
}

struct Model {
    let feiticos: [Feitico] = [Feitico(nome: "Lumos"), Feitico(nome: "Expelliarmus"), Feitico(nome: "Expecto Patronum!")]
    let feiticoSelecionado: Feitico = Feitico(nome: "Lumos")
}



