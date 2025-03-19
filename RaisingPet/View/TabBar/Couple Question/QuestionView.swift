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
            submitQuiz(sendableQuizObject)
        }
    }
    
    func submitQuiz(_ object: TakeQuizRequest) {
        viewModel.takeQuiz(takeQuizObject: object)
    }
    
    var body: some View {
        NavigationStack {
            if isQuizCompleted && viewModel.quizResultLoaded {
                QuizResultView(quizId: quizId)
            } else if viewModel.isLoading {
                LoadingAnimationView()
            } else {
                VStack {
                    if let quiz = viewModel.selectedQuiz?.questions, let questionQuiz = viewModel.selectedQuiz?.questions?[currentQuestionIndex] {
                        if currentQuestionIndex < quiz.count {
                            let question = questionQuiz
                            
                            VStack(spacing: 20) {
                                QuestionOptionView(option: question.options[0])
                                    .onTapGesture {
                                        selectAnswer(question.options[0], questionId: question.id)
                                    }
                                Text("vs")
                                    .font(.nunito(.medium, .title320))
                                QuestionOptionView(option: question.options[1])
                                    .onTapGesture {
                                        selectAnswer(question.options[1], questionId: question.id)
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
                    if !isInitialized { // Yalnızca ilk yüklemede çalışır
                        viewModel.fetchQuizById(quizId: quizId)
                        print("Fetch By Quiz Id ile gönderilen QuizID: \(quizId)")
                        isInitialized = true // Bayrağı true yap
                    }
                }
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

