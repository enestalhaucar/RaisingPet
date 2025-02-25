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
    
    func selectAnswer(_ answer: String, questionId: String) {
        let selectedAnswer = QuizAnswer(questionId: questionId, option: answer)
        selectedAnswers.append(selectedAnswer)
        if currentQuestionIndex < (viewModel.selectedQuiz?.questions.count ?? 0) - 1 {
            withAnimation {
                currentQuestionIndex += 1
            }
        } else {
            isQuizCompleted = true
            submitQuiz()
        }
    }

    func submitQuiz() {
        let request = TakeQuizRequest(quizId: quizId, preAnswers: selectedAnswers)
        sendQuizAnswersToServer(request: request)
    }
    
    func sendQuizAnswersToServer(request: TakeQuizRequest) {
        let url = Utilities.Constants.Endpoints.Quiz.takeQuiz
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Utilities.shared.getUserDetailsFromUserDefaults()["token"] ?? "")",
            "Content-Type": "application/json"
        ]
        
        AF.request(url, method: .post, parameters: request, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .responseDecodable(of: QuizResponse.self) { response in
                switch response.result {
                case .success(let data):
                    print("Quiz başarıyla gönderildi:", data)
                    // Başarıyla gönderildiyse kullanıcıyı sonuç ekranına yönlendir
                    self.isQuizCompleted = true
                case .failure(let error):
                    print("Hata:", error.localizedDescription)
                    // Hata mesajını göster
                }
            }
    }



    
    var body: some View {
        NavigationStack {
            if isQuizCompleted {
                QuizResultView(selectedAnswers: selectedAnswers.map { $0.option })
            } else {
                VStack {
                    if viewModel.isLoading {
                        LoadingAnimationView()
                    } else if let quiz = viewModel.selectedQuiz {
                        if currentQuestionIndex < quiz.questions.count {
                            let question = quiz.questions[currentQuestionIndex]
                            
                            VStack(spacing: 20) {
                                QuestionOptionView(option: question.options[0])
                                    .onTapGesture {
                                        selectAnswer(question.options[0], questionId: question.id)
                                    }
                                Text("vs")
                                    .font(.nunito(.medium, .title320))
                                QuestionOptionView(option: question.options[0])
                                    .onTapGesture {
                                        selectAnswer(question.options[0], questionId: question.id)
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


