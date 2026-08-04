//  s.swift
//  Aula6e7-Desafios
//
//  Created by Turma02-20 on 16/07/26.
//

import Foundation
import Combine

class ViewModel: ObservableObject {
    
    @Published var lessons: [LessonGet] = []
    
    private let service = ServiceLesson()
    private var cancellables = Set<AnyCancellable>()
    
    func fetchAulas() {
        
        guard let url = URL(string: "http://192.168.128.65:1880/pegar_adm_aulas") else {
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
        
        guard let url = URL(string: "http://192.168.128.65:1880/pegar_adm_tutoriais") else {
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
        
        guard let url = URL(string: "http://192.168.128.65:1880/pegar_adm_projetos") else {
            return
        }
        
        service.fetchLesson(url: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }) { lessons in
                self.lessons = lessons
            }
            .store(in: &cancellables)
    }
    
    let full_path: String = "https://ww"

    if let url = URL(string: full_path) {
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        do {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                //This converts the optionals in to non optionals that could be used further on
                //Be aware this will just return when something goes wrong
                guard let data = data, let response = response, error == nil else{

                    print("Something went wrong: error: \(error?.localizedDescription ?? "unkown error")")
                    return
                }
                
                print(response)
                
                decodedAnswer = String(decoding: data, as: UTF8.self)
            }
            
            task.resume()
        }
    }
}
