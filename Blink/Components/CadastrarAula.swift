import SwiftUI

struct CadastroLessonView: View {
    @State private var title = ""
    @State private var type = "Aula"
    @State private var content = ""

    @StateObject private var viewModel = LessonsViewModel()

    var body: some View {
        ZStack {
            Color.blinkOrange
                .ignoresSafeArea()

            RoundedRectangle(cornerRadius: 24)
                .fill(Color.blinkSurface)
                .frame(width: 350, height: 600)

            VStack(spacing: 16) {
                Image("blink1")
                    .resizable()
                    .frame(width: 300, height: 70)
                    .padding(.bottom, 75)

                Text("Publicar tutorial")
                    .font(.headline)
                    .foregroundColor(.blinkOrange)

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

                TextField("Conteúdo", text: $content)
                    .frame(width: 325)
                    .textFieldStyle(.roundedBorder)

                Button("Enviar") {
                    viewModel.cadastrarLesson(
                        title: title,
                        type: type,
                        contents: [content],
                        exercises: nil
                    )

                    title = ""
                    content = ""
                }
                .frame(width: 125, height: 40)
                .background(Color.blinkOrange)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .foregroundColor(.white)
                .disabled(title.isEmpty || content.isEmpty)
            }
        }
    }
}
