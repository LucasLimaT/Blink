//  s.swift
//  Aula6e7-Desafios
//
//  Created by Turma02-20 on 16/07/26.
//

import Foundation
import Combine

class PostsViewModel: ObservableObject {
    
    @Published var posts: [PostGet] = []
    
    private let BASE_URL = "http://192.168.128.25:1880"
    private let service = ServicePost()
    private var cancellables = Set<AnyCancellable>()
    
    func fetchPost() {
        
        guard let url = URL(string: "\(BASE_URL)/pegar_adm_aulas") else {
            return
        }
        
        service.fetchPost(url: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }) { posts in
                self.posts = posts
            }
            .store(in: &cancellables)
    }
    
    func cadastrarPosts(
        author: String,
        comments: [Comment],
        contents: [String],
        tags: [String]
    ) {

        guard let url = URL(
            string: "\(BASE_URL)/postar_user"
        ) else {
            return
        }

        let post = PostPost(
            author: author,
            comments: comments,
            contents: contents,
            tags: tags
        )

        service.postPost(
            url: url,
            post: post
        )
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Aula enviada com sucesso")

                case .failure(let error):
                    print("Erro ao enviar:", error)
                }
            },
            receiveValue: { }
        )
        .store(in: &cancellables)
    }
    
}

