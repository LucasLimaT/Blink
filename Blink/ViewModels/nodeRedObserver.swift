//  s.swift
//  Aula6e7-Desafios
//
//  Created by Turma02-20 on 16/07/26.
//

import Foundation
import Combine

class ViewModel: ObservableObject {
    
    @Published var lessons: [Lesson] = []
    
    private let service = Service()
    private var cancellables = Set<AnyCancellable>()
    
    func fetch() {
        
        guard let url = URL(string: "http://127.0.0.1:1880/pegar_adm_aulas") else {
            return
        }
        
        service.fetchLesson(url: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }) { exercises in
                self.lessons = exercises
            }
            .store(in: &cancellables)
    }
}
