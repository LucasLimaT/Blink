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
        ZStack {
            Color.orange
            
            ZStack{
                
                    LinearGradient(
                        gradient: Gradient(colors: [.white, .white]), // Suas cores aqui
                        startPoint: .topLeading,                      // Ponto inicial
                        endPoint: .bottomTrailing                     // Ponto final
                    )
                    .frame(width: 350, height: 600)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
            }
            
            VStack(spacing: 16) {
                
                Image("blink1")
                    .resizable()
                    .frame(width: 300 , height: 70)
                    .padding(.bottom , 75)
                
                Text("Publicar Tutorial:")
                    .font(.headline)
                    .foregroundStyle(.orange)
                    .padding()
                
                TextField("Título", text: $title)
                    .frame(width: 325)
                    .textFieldStyle(.roundedBorder)
                    
                
                Picker("Tipo", selection: $type) {
                    Text("Aula").tag("Aula")
                    Text("Projeto").tag("Projeto")
                    Text("Tutorial").tag("Tutorial")
                }
                .pickerStyle(.segmented)
                .frame(width: 325)
                .foregroundStyle(.orange)
                
                TextField("Conteúdo", text: $content)
                    .frame(width: 325)
                    .textFieldStyle(.roundedBorder)
                
                Button("Cadastrar") {
                    viewModel.cadastrarLesson(
                        title: title,
                        type: type,
                        contents: [content],
                        exercises: nil
                    )
                }
                .frame(width: 125, height: 40)
                        .background(.orange)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .foregroundStyle(.white)
                
                .disabled(
                    title.isEmpty || content.isEmpty
                )
            }
            .padding()
            
        }
    }
}
