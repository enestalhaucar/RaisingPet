//
//  QuestionView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 6.02.2025.
//

import SwiftUI
import Alamofire

struct QuestionView: View {
    let quizId: String
    @StateObject private var viewModel = CoupleQuestionViewModel()
    @Binding var navigationPath: NavigationPath
    @State private var currentQuestionIndex = 0
    @State private var isQuizCompleted = false
    @State private var selectedAnswers: [QuizAnswer] = []
    @State private var sendableQuizObject: TakeQuizRequest = TakeQuizRequest(quizId: "", preAnswers: [])
    @State private var isInitialized = false

    func selectAnswer(_ answer: String, questionId: String) {
        let selectedAnswer = QuizAnswer(question: .init(_id: questionId), option: answer)
        selectedAnswers.append(selectedAnswer)
        if currentQuestionIndex < (viewModel.selectedQuiz?.questions?.count ?? 0) - 1 {
            withAnimation {
                currentQuestionIndex += 1
            }
        } else {
            isQuizCompleted = true
            print("Seçilen Cevap Sayısı: \(selectedAnswers.count)")
            if selectedAnswers.isEmpty {
                print("gönderilen cevaplar boş")
                return
            }
            sendableQuizObject = TakeQuizRequest(quizId: quizId, preAnswers: selectedAnswers)
            print("Gönderilen Veri: \(sendableQuizObject)")
            Task {
                await submitQuiz(sendableQuizObject)
            }
        }
    }

    func submitQuiz(_ object: TakeQuizRequest) async {
        await viewModel.takeQuiz(takeQuizObject: object)
    }

    var body: some View {
        Group {
            if isQuizCompleted && viewModel.quizResultLoaded {
                QuizResultView(quizId: quizId, navigationPath: $navigationPath)
            } else if viewModel.isLoading {
                LoadingAnimationView()
            } else if let errorMessage = viewModel.errorMessage {
                Text("Hata: \(errorMessage)")
                    .font(.nunito(.medium, .body16))
                    .foregroundColor(.red)
            } else if let quiz = viewModel.selectedQuiz?.questions, !quiz.isEmpty, currentQuestionIndex < quiz.count {
                let question = quiz[currentQuestionIndex]
                VStack(spacing: 20) {
                    QuestionOptionView(option: question.options[0])
                        .onTapGesture {
                            selectAnswer(question.options[0], questionId: question.id)
                        }
                    Text("question_vs".localized())
                        .font(.nunito(.medium, .title320))
                    QuestionOptionView(option: question.options[1])
                        .onTapGesture {
                            selectAnswer(question.options[1], questionId: question.id)
                        }
                }
                .transition(.slide)
                .animation(.easeInOut, value: currentQuestionIndex)
                .padding()
            } else {
                Text("question_no_data".localized())
                    .font(.nunito(.medium, .body16))
            }
        }
        .onAppear {
            currentQuestionIndex = 0
            isQuizCompleted = false
            selectedAnswers.removeAll()
            sendableQuizObject = TakeQuizRequest(quizId: quizId, preAnswers: [])
            if !isInitialized {
                Task {
                    await viewModel.fetchQuizById(quizId: quizId)
                }
                isInitialized = true
            }
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
