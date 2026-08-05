//  s.swift
//  Aula6e7-Desafios
//
//  Created by Turma02-20 on 16/07/26.
//

import Foundation
import Combine

class LessonsViewModel: ObservableObject {
    
    @Published var lessons: [LessonGet] = []
    
    private let BASE_URL = "http://192.168.128.25:1880"
    private let service = ServiceLesson()
    private var cancellables = Set<AnyCancellable>()
    
    func fetchAulas() {
        
        guard let url = URL(string: "\(BASE_URL)/pegar_adm_aulas") else {
            return
        }
        
        service.fetchLesson(url: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }) { lessons in
                self.lessons = lessons
            }
            .store(in: &cancellables)
    }
    
    func fetchTutoriais() {
        
        guard let url = URL(string: "\(BASE_URL)/pegar_adm_tutoriais") else {
            return
        }
        
        service.fetchLesson(url: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }) { lessons in
                self.lessons = lessons
            }
            .store(in: &cancellables)
    }
    
    func fetchProjetos() {
        
        guard let url = URL(string: "\(BASE_URL)/pegar_adm_projetos") else {
            return
        }
        
        service.fetchLesson(url: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }) { lessons in
                self.lessons = lessons
            }
            .store(in: &cancellables)
    }
    
    func cadastrarLesson(
        title: String,
        type: String,
        contents: [String],
        exercises: [Exercise]?
    ) {

        guard let url = URL(
            string: "\(BASE_URL)/postar_user"
        ) else {
            return
        }

        let lesson = LessonPost(
            title: title,
            type: type,
            contents: contents,
            exercises: exercises
        )

        service.postLesson(
            url: url,
            lesson: lesson
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
