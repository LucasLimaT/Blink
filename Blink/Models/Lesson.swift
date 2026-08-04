//
//  Projeto.swift
//  Blink
//
//  Created by Turma02-20 on 30/07/26.
//

struct LessonGet: Codable, Hashable {
    let _id: String
    let _rev: String
    let title: String
    let type: String //Projeto, Aula, Tutoriais
    let contents: [String] // Listas de conteúdos da aula
    let exercises: [Exercise]? // Lista de execercícios (opcinal dependendo do tipo)
}

struct LessonPost: Codable, Hashable {
    let title: String
    let type: String //Projeto, Aula, Tutoriais
    let contents: [String] // Listas de conteúdos da aula
    let exercises: [Exercise]? // Lista de execercícios (opcinal dependendo do tipo)
}

struct Exercise: Codable, Hashable {
    let question: String
    let alternatives: [String]
    let response: String
}
