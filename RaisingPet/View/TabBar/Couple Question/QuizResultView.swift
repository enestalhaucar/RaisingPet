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
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text(calculateMatchMessage())
                    .font(.nunito(.bold, .title320))
                    .multilineTextAlignment(.center)
                    .padding()

                if viewModel.isLoading {
                    LoadingAnimationView()
                } else if let quizResultAnswers = viewModel.quizResult?.answers {
                    VStack(spacing: 15) {
                        ForEach(quizResultAnswers, id: \.question) { answer in
                            HStack {
                                Text(answer.userAnswer ?? "?")
                                    .frame(maxWidth: .infinity)
                                    .padding(10)
                                    .background(Color.blue.opacity(0.2))
                                    .cornerRadius(10)
                                    .font(.nunito(.light, .body16))

                                Text("VS")
                                    .font(.nunito(.medium, .title320))
                                    .bold()
                                    .padding(.horizontal, 8)

                                Text(answer.friendAnswer ?? "?")
                                    .frame(maxWidth: .infinity)
                                    .padding(10)
                                    .background(Color.blue.opacity(0.2))
                                    .cornerRadius(10)
                                    .font(.nunito(.light, .body16))
                            }
                        }
                    }
                    .padding()
                } else {
                    Text("Sonuçlar yüklenemedi.")
                        .font(.nunito(.medium, .body16))
                }

                // Alt buton (Test Tamamlandı ve Geri Dön)
                VStack {
                    Text("Testi başarıyla tamamladın!")
                        .font(.nunito(.medium, .subheadline15))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding()

                    Button(action: {
                        dismiss() // Geri dön
                        // fetchQuizzes() artık CoupleQuestionView’da onChange ile yönetiliyor
                    }) {
                        Text("CoupleQuestion’a Geri Dön")
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .font(.nunito(.medium, .body16))
                    }
                    .padding(.bottom, 20)
                }
            }
        }
        .scrollIndicators(.hidden)
        .navigationTitle("")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    dismiss()
                    Task {
                        await viewModel.fetchQuizById(quizId: quizId)
                    }
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.counterclockwise")
                            .foregroundStyle(.blue)
                        Text("Testi Tekrar Çöz")
                            .font(.nunito(.medium, .caption12))
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .onAppear {
            Task {
                if viewModel.quizResult == nil {
                    await viewModel.fetchQuizResult(quizId: quizId)
                    print("Fetch Quiz Result ile gönderilen quizId: \(quizId)")
                }
            }
        }
    }

    private func calculateMatchPercentage() -> Double {
        guard let accuracy = viewModel.quizResult?.accuracy, let totalQuestions = viewModel.quizResult?.answers?.count, totalQuestions > 0 else { return 0.0 }
        return Double(accuracy)
    }

    private func calculateMatchMessage() -> String {
        let percentage = calculateMatchPercentage()
        if percentage >= 50 {
            return "Birbirinize harika uyum sağlıyorsunuz! (\(Int(percentage))%)"
        } else {
            return "Uyumunuz biraz farklı görünüyor, keşfetmeye devam edin! (\(Int(percentage))%)"
        }
    }
}
