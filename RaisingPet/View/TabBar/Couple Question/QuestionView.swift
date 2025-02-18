//
//  QuestionView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 6.02.2025.
//
import SwiftUI

struct QuestionView: View {
    let quizId: String
    @StateObject private var viewModel = CoupleQuestionViewModel()
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswers: [String] = []
    @State private var isQuizCompleted = false
    
    var body: some View {
        NavigationStack {
            if isQuizCompleted {
                QuizResultView(selectedAnswers: selectedAnswers)
            } else {
                VStack {
                    if viewModel.isLoading {
                        ProgressView("Yükleniyor...")
                    } else if let quiz = viewModel.selectedQuiz {
                        if currentQuestionIndex < quiz.questions.count {
                            let question = quiz.questions[currentQuestionIndex]
                            
                            VStack(spacing: 20) {
                                QuestionOptionView(option: question.options[0])
                                    .onTapGesture {
                                        selectAnswer(question.options[0])
                                    }
                                Text("vs")
                                    .font(.nunito(.medium, .title320))
                                QuestionOptionView(option: question.options[1])
                                    .onTapGesture {
                                        selectAnswer(question.options[1])
                                    }
                            }
                            .transition(.slide)
                            .animation(.easeInOut, value: currentQuestionIndex)
                            .padding()
                        }
                    } else {
                        Text("Veri bulunamadı")
                    }
                }
                .onAppear {
                    viewModel.fetchQuizDetails(quizId: quizId)
                }
            }
        }
    }
    
    func selectAnswer(_ answer: String) {
        selectedAnswers.append(answer)
        
        if currentQuestionIndex < (viewModel.selectedQuiz?.questions.count ?? 0) - 1 {
            withAnimation {
                currentQuestionIndex += 1
            }
        } else {
            isQuizCompleted = true
        }
    }
}

struct QuestionOptionView: View {
    let option: String
    var body: some View {
        Text(option)
            .font(.nunito(.light, .headline17))
            .frame(width: Utilities.Constants.widthEight, height: 65)
            .background(Color.blue.opacity(0.2))
            .cornerRadius(20)
    }
}
