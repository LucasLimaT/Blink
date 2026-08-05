//
//  Service.swift
//  Blink
//
//  Created by Turma02-20 on 03/08/26.
//

import Foundation
import Combine

struct ServicePost {
    func fetchPost(url: URL) -> AnyPublisher<[PostGet], Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [PostGet].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func postPost(
        url: URL,
        post: PostPost
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
            request.httpBody = try JSONEncoder().encode(post)
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

