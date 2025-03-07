//
//  QuizResultView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 17.02.2025.
//

import SwiftUI

struct QuizResultView: View {
    let quizId: String
    @StateObject private var viewModel = CoupleQuestionViewModel()
    @State private var percentage: Double = 0.0
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Birbirimize bu kadar iyi uyum sağlıyoruz!")
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    if viewModel.isLoading {
                        LoadingAnimationView()
                    } else if let quizResultAnswers = viewModel.quizResult?.answers {
                        VStack(spacing: 15) {
                            ForEach(quizResultAnswers, id: \.self) { answer in
                                HStack {
                                    
                                    Text(answer.userAnswer ?? "N/A")
                                        .frame(maxWidth: .infinity)
                                        .padding(10)
                                        .background(Color.blue.opacity(0.2))
                                        .cornerRadius(10)
                                    
                                    Text("VS")
                                        .font(.nunito(.medium, .title320))
                                        .bold()
                                        .padding(.horizontal, 8)
                                    
                                    Text(answer.friendAnswer ?? "?")
                                        .frame(maxWidth: .infinity)
                                        .padding(10)
                                        .background(Color.blue.opacity(0.2))
                                        .cornerRadius(10)
                                }
                            }
                        }
                        .padding()
                    } else {
                        Text("Sonuçlar yüklenemedi.")
                    }
                    
                    Button(action: {
                        // Testi tekrar çözmek için bir aksiyon eklenebilir
                    }) {
                        Text("Testi Tekrar Çöz")
                            .frame(width: 200, height: 50)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }
            }
            .onAppear {
                if viewModel.quizResult == nil {
                    viewModel.fetchQuizResult(quizId: quizId)
                    print("Fetch Quiz Result ile gönderilen quizId: \(quizId)")
                }
            }
        }
    }
    
    private func calculateMatchPercentage() -> Double {
        guard let quizResult = viewModel.quizResult, let totalQuestions = quizResult.answers?.count else { return 0.0 }
        return totalQuestions > 0 ? Double(5) / Double(totalQuestions) * 100 : 0.0
    }
}
