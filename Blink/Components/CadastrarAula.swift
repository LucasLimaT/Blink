//
//  NovaAula.swift
//  Blink
//
//  Created by Turma02-20 on 04/08/26.
//

import SwiftUI

struct CadastroLessonView: View {

    @StateObject private var viewModel = ViewModel()

    @State private var title = ""
    @State private var type = "Aula"
    @State private var content = ""

    var body: some View {
        VStack(spacing: 16) {

            TextField("Título", text: $title)
                .textFieldStyle(.roundedBorder)

            Picker("Tipo", selection: $type) {
                Text("Aula").tag("Aula")
                Text("Projeto").tag("Projeto")
                Text("Tutorial").tag("Tutorial")
            }
            .pickerStyle(.segmented)

            TextField("Conteúdo", text: $content)
                .textFieldStyle(.roundedBorder)

            Button("Cadastrar") {
                viewModel.cadastrarLesson(
                    title: title,
                    type: type,
                    contents: [content],
                    exercises: nil
                )
            }
            .disabled(
                title.isEmpty || content.isEmpty
            )
        }
        .padding()
    }
}
