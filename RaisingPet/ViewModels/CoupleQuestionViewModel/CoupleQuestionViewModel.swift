//
//  CoupleQuestionViewModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 4.02.2025.
//

import Foundation
import Alamofire

@MainActor
class CoupleQuestionViewModel: ObservableObject {
    @Published var quiz: [QuizModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var selectedQuiz: GetQuizByIdResponseModel.QuizDetailModel?
    @Published var quizResult: QuizResultForQuizResponseFormattedQuizResult?
    @Published var quizResultLoaded: Bool = false
    var cachedQuizResults: [String: QuizResultForQuizResponseFormattedQuizResult] = [:]

    private var headers: HTTPHeaders {
        let token = Utilities.shared.getUserDetailsFromUserDefaults()["token"] ?? ""
        return [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
    }

    func checkFriendship() async -> Bool {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        let url = Utilities.Constants.Endpoints.Friends.list

        do {
            let response = try await AF.request(url, method: .get, headers: headers)
                .validate()
                .serializingDecodable(FriendsResponseModel.self)
                .value
            return !response.data.friends.isEmpty
        } catch {
            errorMessage = "Arkadaş kontrolü başarısız: \(error.localizedDescription)"
            print("Check friendship error: \(error)")
            return false
        }
    }

    func fetchQuizzes() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        let url = Utilities.Constants.Endpoints.Quiz.getUserQuizes

        do {
            let response = try await AF.request(url, method: .get, headers: headers)
                .validate()
                .serializingDecodable(GetUserQuizes.self)
                .value
            self.quiz = response.data
        } catch {
            errorMessage = "Hata: Quiz’ler yüklenemedi - \(error.localizedDescription)"
            print("Fetch quizzes error: \(error)")
        }
    }

    func fetchQuizById(quizId: String) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        let url = Utilities.Constants.Endpoints.Quiz.getQuizById.replacingOccurrences(of: ":id", with: quizId)

        do {
            let response = try await AF.request(url, method: .get, headers: headers)
                .validate()
                .serializingDecodable(GetQuizByIdResponseModel.self)
                .value
            self.selectedQuiz = response.data.data
        } catch {
            errorMessage = "Hata: Quiz yüklenemedi - \(error.localizedDescription)"
            print("Fetch quiz by id error: \(error)")
        }
    }

    func takeQuiz(takeQuizObject: TakeQuizRequest) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        guard let token = Utilities.shared.getUserDetailsFromUserDefaults()["token"] else {
            errorMessage = "Hata: Token bulunamadı."
            return
        }
        guard let quizId = takeQuizObject.quizId else {
            errorMessage = "Hata: Quiz ID eksik."
            return
        }
        guard let answers = takeQuizObject.preAnswers, !answers.isEmpty else {
            errorMessage = "Hata: Cevaplar eksik."
            return
        }

        let url = Utilities.Constants.Endpoints.Quiz.takeQuiz
        let headers = self.headers

        do {
            let response = try await AF.request(url, method: .post, parameters: takeQuizObject, encoder: JSONParameterEncoder.default, headers: headers)
                .validate()
                .serializingDecodable(TakeQuizResponse.self)
                .value
            print("TakeQuiz Başarılı: \(response)")
            await fetchQuizResult(quizId: quizId) {
                self.quizResultLoaded = true
                // takeQuiz sonrası cache’i güncelle
                self.cachedQuizResults[quizId] = self.quizResult
            }
        } catch {
            errorMessage = "Hata: Quiz gönderilemedi - \(error.localizedDescription)"
            print("Take quiz error: \(error)")
        }
    }

    func fetchQuizResult(quizId: String, completion: @escaping () -> Void = {}) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        let url = Utilities.Constants.Endpoints.Quiz.quizResultForQuiz
        let parameters: [String: String] = ["quizId": quizId]
        let headers = self.headers

        do {
            let response = try await AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers)
                .validate()
                .serializingDecodable(QuizResultForQuizResponse.self)
                .value
            self.quizResult = response.data?.formattedQuizResult
            self.cachedQuizResults[quizId] = self.quizResult // Cache’i güncelle
            completion()
        } catch let error as AFError where error.responseCode == 500 {
            print("Fetch quiz result error (500): \(error.localizedDescription)")
            self.quizResult = nil // İkisi de çözmemiş, QuestionView’e yönlendir
            self.cachedQuizResults[quizId] = nil // Cache’i temizle
            completion()
        } catch {
            errorMessage = "Hata: Quiz sonucu yüklenemedi - \(error.localizedDescription)"
            print("Fetch quiz result error: \(error)")
            self.quizResult = nil
            self.cachedQuizResults[quizId] = nil // Cache’i temizle
            completion()
        }
    }

    // Kullanıcının quiz’i çözüp çözmediğini kontrol et
    func isUserDoneQuiz(quizId: String) async -> (Bool, Bool)? { // (isDone, hasAnswers)
        if let cachedResult = cachedQuizResults[quizId] {
            print("isUserDoneQuiz: Cache’ten alındı, quizId: \(quizId)")
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
