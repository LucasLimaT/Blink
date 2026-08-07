//
//  ServiceLesson.swift
//  Blink
//
//  Created by Turma02-20 on 03/08/26.
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

    func postLesson(
        url: URL,
        lesson: LessonPost
    ) -> AnyPublisher<Void, Error> {

        var request = URLRequest(url: url)

        request.httpMethod = "POST"
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Accept"
        )

        do {
            request.httpBody = try JSONEncoder().encode(lesson)
        } catch {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { _, response in

                guard let httpResponse = response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }

                guard 200...299 ~= httpResponse.statusCode else {
                    throw URLError(.badServerResponse)
                }

                return ()
            }
            .eraseToAnyPublisher()
    }
}
