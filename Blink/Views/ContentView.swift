//
//  ContentView.swift
//  Blink
//
//  Created by Turma02-20 on 30/07/26.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            ForEach(viewModel.lessons, id: \.self) {lesson in
                Text(lesson.title)
                Text("\(lesson.type)")
            }

        }
        .onAppear(){
            viewModel.fetch()
        }
        
        .padding()
    }
}

#Preview {
    ContentView()
}
