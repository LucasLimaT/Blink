import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = LessonsViewModel()
    @State private var showForm = false

    var body: some View {
        VStack {
            ScrollView {
                ForEach(viewModel.lessons, id: \._id) { lesson in
                    Text(lesson.title)
                    Text(lesson.type)

                    ForEach(lesson.contents, id: \.self) { content in
                        Text(content)
                    }
                }

                Button("Cadastrar aula") {
                    showForm = true
                }
            }
        }
        .onAppear {
            viewModel.fetchAulas()
        }
        .sheet(isPresented: $showForm) {
            CadastroLessonView()
        }
        .padding()
    }
}
