//
//  Exercicio.swift
//  Blink
//
//  Created by Turma02-20 on 30/07/26.
//

struct Exercise: Codable, Hashable {
    let _id: String
    let _rev: String
    let question: String
    let alternatives: [String]
    let responses: String
}
