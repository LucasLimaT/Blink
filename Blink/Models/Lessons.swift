//
//  Projeto.swift
//  Blink
//
//  Created by Turma02-20 on 30/07/26.
//

struct Lessons: Codable, Hashable {
    let _id: String
    let _rev: String
    let title: String
    let type: String //Projeto, Aula, Tutoriais
    let contents: [String] // Listas de conteúdos da aula
    let exercicios: [Exercise]? // Lista de execercícios (opcinal dependendo do tipo)
}
