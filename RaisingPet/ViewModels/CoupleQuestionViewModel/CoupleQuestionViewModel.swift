//
//  CoupleQuestionViewModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 4.02.2025.
//

import Foundation
import Combine

@MainActor
class CoupleQuestionViewModel: ObservableObject {
    @Published var quiz: [QuizModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var selectedQuiz: GetQuizByIdResponseModel.QuizDetailModel?
    @Published var quizResult: QuizResultForQuizResponseFormattedQuizResult?
    @Published var quizResultLoaded: Bool = false
    var cachedQuizResults: [String: QuizResultForQuizResponseFormattedQuizResult] = [:]

    // Repository'ler
    private let friendsRepository: FriendsRepository
    private let quizRepository: QuizRepository

    // MARK: - Initialization
    init(
        friendsRepository: FriendsRepository = RepositoryProvider.shared.friendsRepository,
        quizRepository: QuizRepository = RepositoryProvider.shared.quizRepository
    ) {
        self.friendsRepository = friendsRepository
        self.quizRepository = quizRepository
    }

    func checkFriendship() async -> Bool {
        isLoading = true
        errorMessage = nil

        do {
            let response = try await friendsRepository.listFriends()
            isLoading = false
            return !response.data.friends.isEmpty
        } catch let error as NetworkError {
            isLoading = false
            errorMessage = error.errorMessage
            print("Check friendship error: \(error)")
            return false
        } catch {
            isLoading = false
            errorMessage = "Arkadaş kontrolü başarısız: \(error.localizedDescription)"
            print("Check friendship error: \(error)")
            return false
        }
    }

    func fetchQuizzes() async {
        isLoading = true
        errorMessage = nil

        do {
            let response = try await quizRepository.getUserQuizzes()
            self.quiz = response.data
            isLoading = false
        } catch let error as NetworkError {
            isLoading = false
            errorMessage = error.errorMessage
            print("Fetch quizzes error: \(error)")
        } catch {
            isLoading = false
            errorMessage = "Hata: Quiz'ler yüklenemedi - \(error.localizedDescription)"
            print("Fetch quizzes error: \(error)")
        }
    }

    func fetchQuizById(quizId: String) async {
        isLoading = true
        errorMessage = nil

        do {
            let response = try await quizRepository.getQuizById(id: quizId)
            self.selectedQuiz = response.data.data
            isLoading = false
        } catch let error as NetworkError {
            isLoading = false
            errorMessage = error.errorMessage
            print("Fetch quiz by id error: \(error)")
        } catch {
            isLoading = false
            errorMessage = "Hata: Quiz yüklenemedi - \(error.localizedDescription)"
            print("Fetch quiz by id error: \(error)")
        }
    }

    func takeQuiz(takeQuizObject: TakeQuizRequest) async {
        isLoading = true
        errorMessage = nil

        guard let quizId = takeQuizObject.quizId else {
            isLoading = false
            errorMessage = "Hata: Quiz ID eksik."
            return
        }
        guard let answers = takeQuizObject.preAnswers, !answers.isEmpty else {
            isLoading = false
            errorMessage = "Hata: Cevaplar eksik."
            return
        }

        // TakeQuizRequest formatını Repository'nin istediği formata dönüştür
        var answersDict: [String: String] = [:]
        for answer in answers {
            answersDict[answer.question._id] = answer.option
        }

        do {
            // Repository üzerinden isteği yap
            let response = try await quizRepository.takeQuiz(quizId: quizId, answers: answersDict)
            print("TakeQuiz Başarılı")
            isLoading = false

            await fetchQuizResult(quizId: quizId) {
                self.quizResultLoaded = true
                // takeQuiz sonrası cache'i güncelle
                self.cachedQuizResults[quizId] = self.quizResult
            }
        } catch let error as NetworkError {
            isLoading = false
            errorMessage = error.errorMessage
            print("Take quiz error: \(error)")
        } catch {
            isLoading = false
            errorMessage = "Hata: Quiz gönderilemedi - \(error.localizedDescription)"
            print("Take quiz error: \(error)")
        }
    }

    func fetchQuizResult(quizId: String, completion: @escaping () -> Void = {}) async {
        isLoading = true
        errorMessage = nil

        do {
            let response = try await quizRepository.quizResultForQuiz(quizId: quizId)
            self.quizResult = response.data?.formattedQuizResult
            self.cachedQuizResults[quizId] = self.quizResult // Cache'i güncelle
            isLoading = false
            completion()
        } catch let error as NetworkError where error.errorMessage.contains("500") {
            print("Fetch quiz result error (500): \(error.errorMessage)")
            self.quizResult = nil // İkisi de çözmemiş, QuestionView'e yönlendir
            self.cachedQuizResults[quizId] = nil // Cache'i temizle
            isLoading = false
            completion()
        } catch let error as NetworkError {
            isLoading = false
            errorMessage = error.errorMessage
            print("Fetch quiz result error: \(error)")
            self.quizResult = nil
            self.cachedQuizResults[quizId] = nil // Cache'i temizle
            completion()
        } catch {
            isLoading = false
            errorMessage = "Hata: Quiz sonucu yüklenemedi - \(error.localizedDescription)"
            print("Fetch quiz result error: \(error)")
            self.quizResult = nil
            self.cachedQuizResults[quizId] = nil // Cache'i temizle
            completion()
        }
    }

    // Kullanıcının quiz'i çözüp çözmediğini kontrol et
    func isUserDoneQuiz(quizId: String) async -> (Bool, Bool)? { // (isDone, hasAnswers)
        if let cachedResult = cachedQuizResults[quizId] {
            print("isUserDoneQuiz: Cache'ten alındı, quizId: \(quizId)")
            let hasUserAnswers = cachedResult.answers?.contains(where: { $0.userAnswer != nil }) ?? false
            let hasFriendAnswers = cachedResult.answers?.contains(where: { $0.friendAnswer != nil }) ?? false
            return (hasUserAnswers, hasFriendAnswers)
        }
        await fetchQuizResult(quizId: quizId)
        if let result = self.quizResult {
            print("isUserDoneQuiz: Taze veri çekildi, quizId: \(quizId)")
            let hasUserAnswers = result.answers?.contains(where: { $0.userAnswer != nil }) ?? false
            let hasFriendAnswers = result.answers?.contains(where: { $0.friendAnswer != nil }) ?? false
            return (hasUserAnswers, hasFriendAnswers)
        }
        return nil // Hata durumunda null
    }
}
