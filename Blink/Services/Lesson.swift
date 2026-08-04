//
//  Service.swift
//  Blink
//
//  Created by Turma02-20 on 03/08/26.
//


//
//  crud.swift
//  Aula6e7-Desafios
//
//  Created by Turma02-20 on 16/07/26.
//

import Foundation
import Combine

struct ServiceLesson {
    func fetchLesson(url: URL) -> AnyPublisher<[LessonGet], Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [LessonGet].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
