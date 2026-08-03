//
//  Aulas.swift
//  
//
//  Created by Turma02-20 on 30/07/26.
//

struct Post: Codable, Hashable {
    let _id: String
    let _rev: String
    let author: String
    let comments: [Comment]
    let contents: [String]
    let tags: [String]
}

struct Comment: Codable, Hashable {
    let author: String
    let content: String
}
