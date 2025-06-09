//
//  QuestionView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 6.02.2025.
//

import SwiftUI

struct CoupleQuestionView: View {
    @StateObject private var viewModel = CoupleQuestionViewModel()
    @State private var selectedTab: Tab = .harmony
    @State private var selectedIcon: Int = 0
    @State private var sentQuizId: String = ""
    @State private var shouldNavigateToFriends = false
    @State private var isNavigateFriends = false
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 20) {
                // Tab Bar
                HStack(spacing: 20) {
                    CoupleQuestionHeaderBarIcon(imageName: "harmonyIcon", text: "couple_question_harmony".localized(), color: .blue.opacity(0.2), isSelected: selectedIcon == 0)
                        .onTapGesture {
                            selectedIcon = 0
                            selectedTab = .harmony
                        }
                    CoupleQuestionHeaderBarIcon(imageName: "aiTerapistIcon", text: "couple_question_ai_therapist".localized(), color: .red.opacity(0.05), isSelected: selectedIcon == 1)
                        .onTapGesture {
                            selectedIcon = 1
                            selectedTab = .aiTherapist
                        }
                }
                .frame(height: 75)
                .background(Color.white)
                .font(.nunito(.medium, .body16))

                Rectangle()
                    .foregroundStyle(.gray.opacity(0.2))
                    .frame(width: ConstantManager.Layout.screenWidth, height: 6)

                // Alt İçerik (Koşullu Gösterim)
                if selectedTab == .harmony {
                    if viewModel.isLoading {
                        LoadingAnimationView()
                    } else if let errorMessage = viewModel.errorMessage, errorMessage.contains("500") == false {
                        Text(errorMessage)
                            .font(.nunito(.medium, .body16))
                            .foregroundColor(.red)
                    } else if shouldNavigateToFriends {
                        VStack {
                            Text("couple_question_no_friends_message".localized())
                                .font(.nunito(.medium, .subheadline15))
                                .multilineTextAlignment(.center)
                                .padding()
                            Button(action: {
                                shouldNavigateToFriends = false
                                navigateToFriends()
                            }) {
                                Text("couple_question_add_friend".localized())
                                    .frame(width: 200, height: 50)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .font(.nunito(.medium, .body16))
                            }
                        }
                    } else if viewModel.quiz.isEmpty {
                        Text("couple_question_no_data".localized())
                            .font(.nunito(.medium, .body16))
                    } else {
                        ScrollView {
                            VStack(spacing: 15) {
                                ForEach(viewModel.quiz.sorted(by: { ($0.title ?? "-") < ($1.title ?? "-") }), id: \.id) { quiz in
                                    QuizRowView(quiz: quiz, viewModel: viewModel, navigationPath: $navigationPath)
                                }
                            }
                        }
                        .scrollIndicators(.hidden)
                    }
                } else {
                    AITherapistView()
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color(.systemBackground))
            .navigationDestination(isPresented: $isNavigateFriends) {
                FriendsView()
            }
            .navigationDestination(for: String.self) { destination in
                if destination.starts(with: "question_") {
                    let quizId = destination.replacingOccurrences(of: "question_", with: "")
                    QuestionView(quizId: quizId, navigationPath: $navigationPath)
                } else if destination.starts(with: "result_") {
                    let quizId = destination.replacingOccurrences(of: "result_", with: "")
                    QuizResultView(quizId: quizId, navigationPath: $navigationPath)
                } else {
                    EmptyView()
                }
            }
        }
        .onAppear {
            Task {
                let hasFriend = await viewModel.checkFriendship()
                if !hasFriend {
                    shouldNavigateToFriends = true
                } else {
                    await viewModel.fetchQuizzes()
                }
            }
        }
        .onChange(of: navigationPath) {
            if navigationPath.isEmpty {
                Task {
                    let hasFriend = await viewModel.checkFriendship()
                    if !hasFriend {
                        shouldNavigateToFriends = true
                    } else {
                        print("navigationPath boşaldı, quiz'ler yeniden çekiliyor ve cache temizleniyor")
                        viewModel.cachedQuizResults.removeAll()
                        await viewModel.fetchQuizzes()
                    }
                }
            }
        }
    }

    private func navigateToFriends() {
        isNavigateFriends = true
    }
}

struct QuizRowView: View {
    let quiz: QuizModel
    @ObservedObject var viewModel: CoupleQuestionViewModel
    @Binding var navigationPath: NavigationPath
    @State private var isUserDone: Bool = false
    @State private var hasFriendDone: Bool = false
    @State private var isLoading: Bool = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .frame(height: 56)
                .foregroundStyle(.blue.opacity(0.09))

            HStack(spacing: 25) {
                Image(systemName: getCategoryIcon(quiz.category))
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(.gray)

                Text(quiz.title ?? "-")
                    .font(.nunito(.light, .body16))
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Spacer()

                if quiz.quizStatus == .continued {
                    Image(systemName: "clock")
                        .foregroundStyle(.orange)
                } else if quiz.quizStatus == .finished {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.green)
                }
            }
            .padding(.horizontal, 20)
        }
        .frame(width: ConstantManager.Layout.widthWithoutEdge, alignment: .leading)
        .onTapGesture {
            Task {
                isLoading = true
                print("Quiz'e tıklandı: \(quiz.id ?? "-")")
                if let (userDone, friendDone) = await viewModel.isUserDoneQuiz(quizId: quiz.id ?? "") {
                    isUserDone = userDone
                    hasFriendDone = friendDone
                    print("isUserDone: \(isUserDone), hasFriendDone: \(hasFriendDone)")
                } else {
                    isUserDone = false
                    hasFriendDone = false
                    print("Hata durumu: isUserDone ve hasFriendDone false")
                }
                isLoading = false

                if !isUserDone {
                    print("QuestionView'e yönlendiriliyor: question_\(quiz.id ?? "-")")
                    navigationPath.append("question_\(quiz.id ?? "-")")
                } else {
                    print("QuizResultView'e yönlendiriliyor: result_\(quiz.id ?? "-")")
                    navigationPath.append("result_\(quiz.id ?? "-")")
                }
            }
        }
        .overlay {
            if isLoading {
                ProgressView()
            }
        }
    }

    private func getCategoryIcon(_ category: QuizCategoryModel?) -> String {
        switch category {
        case .drink: return "cup.and.saucer"
        case .fashion: return "tshirt"
        case .food: return "fork.knife"
        case .hobby: return "paintbrush"
        case .movie: return "film"
        case .music: return "music.note"
        case .pet: return "pawprint"
        case .sport: return "figure.walk"
        case .tech: return "laptopcomputer"
        case .travel: return "airplane"
        case .unknown, .none: return "questionmark.circle"
        }
    }
}

enum Tab {
    case harmony, aiTherapist
}

struct CoupleQuestionHeaderBarIcon: View {
    var imageName: String
    var text: String
    var color: Color
    var isSelected: Bool
    var body: some View {
        HStack(spacing: 10) {
            Image(imageName)
                .resizable()
                .frame(width: 30, height: 30)
            Text(text)
                .font(.nunito(.medium, .body16))
        }
        .padding()
        .background(color)
        .background(in: RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
        )
    }
}

struct AITherapistView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "wrench.and.screwdriver")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundStyle(.gray.opacity(0.4))
            VStack(spacing: 8) {
                Text("ai_therapist_development_title".localized())
                    .font(.nunito(.semiBold, .title222))
                    .foregroundStyle(.primary)
                Text("ai_therapist_under_development".localized())
                    .font(.nunito(.regular, .body16))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 24)
        }
        .padding()
    }
}
