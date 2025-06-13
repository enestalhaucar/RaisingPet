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
    @Binding var navigationPath: NavigationPath
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
                } else if let quizResultAnswers = viewModel.quizResult?.answers, !quizResultAnswers.isEmpty {
                    VStack(spacing: 15) {
                        ForEach(quizResultAnswers, id: \.question) { answer in
                            HStack {
                                Text(answer.userAnswer ?? "?")
                                    .frame(maxWidth: .infinity)
                                    .padding(10)
                                    .background(
                                        (answer.userAnswer != nil && answer.userAnswer == answer.friendAnswer) ?
                                        Color.green.opacity(0.2) : Color.blue.opacity(0.2)
                                    )
                                    .cornerRadius(10)
                                    .font(.nunito(.light, .body16))

                                Text("quiz_result_vs".localized())
                                    .font(.nunito(.medium, .title320))
                                    .bold()
                                    .padding(.horizontal, 8)

                                Text(answer.friendAnswer ?? "?")
                                    .frame(maxWidth: .infinity)
                                    .padding(10)
                                    .background(
                                        (answer.friendAnswer != nil && answer.userAnswer == answer.friendAnswer) ?
                                        Color.green.opacity(0.2) : Color.blue.opacity(0.2)
                                    )
                                    .cornerRadius(10)
                                    .font(.nunito(.light, .body16))
                            }
                        }
                    }
                    .padding()
                } else {
                    Text("quiz_result_no_data".localized())
                        .font(.nunito(.medium, .body16))
                }

                // Alt buton (Test Tamamlandı ve Geri Dön)
                VStack {
                    Text("quiz_result_completed".localized())
                        .font(.nunito(.medium, .subheadline15))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding()

                    Button(action: {
                        dismiss() // Geri dön
                    }) {
                        Text("quiz_result_back_to_couple_question".localized())
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
                    navigationPath.append("question_\(quizId)")
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.counterclockwise")
                            .foregroundStyle(.blue)
                        Text("quiz_result_retake_quiz".localized())
                            .font(.nunito(.medium, .caption12))
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .onAppear {
            Task {
                // Sadece quizId değiştiyse veya sonuçlar henüz yüklenmediyse veri çek.
                if viewModel.quizResult == nil || viewModel.quizResult?.quizId != quizId {
                    await viewModel.fetchQuizResult(quizId: quizId)
                }
            }
        }
    }

    /// Arkadaşın testi çözüp çözmediğini kontrol eder.
    private var friendHasAnswered: Bool {
        // Cevap listesinde, arkadaşın cevabının nil olduğu bir tane bile varsa, testi tamamlamamış demektir.
        guard let answers = viewModel.quizResult?.answers else { return false }
        return !answers.contains { $0.friendAnswer == nil }
    }

    private func calculateMatchPercentage() -> Double {
        guard let result = viewModel.quizResult, let answers = result.answers, !answers.isEmpty else { return 0.0 }
        // Gerçek yüzdeyi hesapla: (Eşleşen Cevap Sayısı / Toplam Soru Sayısı) * 100
        return (Double(result.accuracy ?? 0) / Double(answers.count)) * 10.0
    }

    private func calculateMatchMessage() -> String {
        // Önce arkadaşın cevap verip vermediğini kontrol et.
        guard friendHasAnswered else {
            return "quiz_result_waiting_friend".localized()
        }

        let percentage = calculateMatchPercentage()

        // Yüzdeye göre farklı mesajlar göster.
        switch percentage {
        case 81...100:
            return String(format: "quiz_result_match_perfect".localized(), Int(percentage))
        case 61...80:
            return String(format: "quiz_result_match_great".localized(), Int(percentage))
        case 41...60:
            return String(format: "quiz_result_match_good".localized(), Int(percentage))
        case 21...40:
            return String(format: "quiz_result_match_okay".localized(), Int(percentage))
        default: // 0-20
            return String(format: "quiz_result_match_low".localized(), Int(percentage))
        }
    }
}
