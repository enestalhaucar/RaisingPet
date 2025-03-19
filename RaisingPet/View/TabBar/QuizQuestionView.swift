//
//  QuizQuestionView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 17.12.2024.
//

import SwiftUI



// MARK: - Soru Modeli
struct QuizQuestion: Identifiable {
    let id = UUID()
    let question: String
    let option1: String
    let option2: String
}

// MARK: - ViewModel
class QuizViewModel: ObservableObject {
    @Published var questions: [QuizQuestion] = [
        QuizQuestion(question: "Hot or Cold?", option1: "Hot Americano", option2: "Iced Americano"),
        QuizQuestion(question: "Tea or Coffee?", option1: "Tea", option2: "Coffee"),
        QuizQuestion(question: "Cake or Cookie?", option1: "Cake", option2: "Cookie"),
        QuizQuestion(question: "Pizza or Burger?", option1: "Pizza", option2: "Burger"),
        QuizQuestion(question: "Pasta or Salad?", option1: "Pasta", option2: "Salad"),
        // Diğer soruları ekleyebilirsin
    ]
    @Published var currentIndex: Int = 0
    @Published var answers: [String] = []
    
    func selectAnswer(_ answer: String) {
        answers.append(answer)
        if currentIndex < questions.count - 1 {
            withAnimation {
                currentIndex += 1
            }
        }
    }
}

struct QuizQuestionView: View {
    @StateObject private var viewModel = QuizViewModel()
    @State private var showResults = false
    var title : String
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Gradient Arkaplan
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.yellow.opacity(0.5),
                        Color.yellow.opacity(0.3)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // Soru Gösterimi
                VStack {
                    TabView(selection: $viewModel.currentIndex) {
                        ForEach(viewModel.questions.indices, id: \.self) { index in
                            let question = viewModel.questions[index]
                            
                            VStack(spacing: 20) {
                                Text(question.question)
                                    .font(.title)
                                    .bold()
                                    .multilineTextAlignment(.center)
                                
                                Button(action: {
                                    viewModel.selectAnswer(question.option1)
                                    checkIfLastQuestion()
                                }) {
                                    RoundedRectangle(cornerRadius: 20)
                                        .foregroundStyle(.white)
                                        .frame(height: 60)
                                        .overlay(
                                            Text(question.option1)
                                                .foregroundColor(.black)
                                                .bold()
                                        )
                                }
                                
                                Text("vs")
                                    .font(.title2)
                                
                                Button(action: {
                                    viewModel.selectAnswer(question.option2)
                                    checkIfLastQuestion()
                                }) {
                                    RoundedRectangle(cornerRadius: 20)
                                        .foregroundStyle(.white)
                                        .frame(height: 60)
                                        .overlay(
                                            Text(question.option2)
                                                .foregroundColor(.black)
                                                .bold()
                                        )
                                }
                            }
                            .padding()
                            .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                }
            }
            .navigationTitle("\(title)")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $showResults) {
                QuizResultsView(answers: viewModel.answers)
            }
        }
    }
    
    private func checkIfLastQuestion() {
        if viewModel.currentIndex == viewModel.questions.count - 1 {
            showResults = true
        }
    }
}

// MARK: - Sonuç Görüntüleme Sayfası
struct QuizResultsView: View {
    let answers: [String]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Your Answers")
                .font(.largeTitle)
                .bold()
            
            ForEach(answers.indices, id: \.self) { index in
                Text("\(index + 1). \(answers[index])")
                    .font(.title2)
                    .padding(.vertical, 5)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("results".localized())
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    QuizQuestionView(title : "Food")
}
