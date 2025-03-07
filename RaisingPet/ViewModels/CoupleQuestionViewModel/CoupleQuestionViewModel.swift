//
//  CoupleQuestionViewModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 4.02.2025.
//

import Foundation
import Alamofire


class CoupleQuestionViewModel: ObservableObject {
    @Published var quiz: [QuizModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var selectedQuiz: GetQuizByIdResponseModel.QuizDetailModel?
    @Published var quizResult: QuizResultForQuizResponseFormattedQuizResult? // quizResultForQuiz sonucu
    
    func fetchQuizzes() {
        let url = Utilities.Constants.Endpoints.Quiz.getUserQuizes
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Utilities.shared.getUserDetailsFromUserDefaults()["token"] ?? "")",
            "Content-Type": "application/json"
        ]
        isLoading = true
        errorMessage = nil
        
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: GetUserQuizes.self) { response in
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch response.result {
                    case .success(let data):
                        print(data)
                        self.quiz = data.data
                    case .failure(let error):
                        self.errorMessage = "Hata:1 \(error.localizedDescription)"
                    }
                }
            }
    }
    
    func fetchQuizById(quizId: String) {
        let url = Utilities.Constants.Endpoints.Quiz.getQuizById.replacingOccurrences(of: ":id", with: quizId)
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Utilities.shared.getUserDetailsFromUserDefaults()["token"] ?? "")",
            "Content-Type": "application/json"
        ]
        
        isLoading = true
        errorMessage = nil
        
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: GetQuizByIdResponseModel.self) { response in
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch response.result {
                    case .success(let data):
                        self.selectedQuiz = data.data.data
                        print(self.selectedQuiz as Any)
                    case .failure(let error):
                        self.errorMessage = "Hata:2 \(error.localizedDescription)"
                        print(self.errorMessage as Any)
                    }
                }
            }
    }
    
    func takeQuiz(takeQuizObject: TakeQuizRequest) {
        let url = Utilities.Constants.Endpoints.Quiz.takeQuiz
        
        guard let token = Utilities.shared.getUserDetailsFromUserDefaults()["token"] else {
            self.errorMessage = "Hata: Token bulunamadı."
            self.isLoading = false
            return
        }
        guard let quizId = takeQuizObject.quizId else {
            self.errorMessage = "Hata: Quiz ID eksik."
            self.isLoading = false
            return
        }
        guard let answers = takeQuizObject.preAnswers, !answers.isEmpty else {
            self.errorMessage = "Hata: Cevaplar eksik."
            self.isLoading = false
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        isLoading = true
        errorMessage = nil
        
        AF.request(url, method: .post, parameters: takeQuizObject, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .responseString { response in
                print("Sunucu Yanıtı : \(String(describing: response.value))")
            }
            .responseDecodable(of: TakeQuizResponse.self) { response in
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch response.result {
                    case .success(let data):
                        print("TakeQuiz Başarılı: \(data)")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            self.fetchQuizResult(quizId: quizId)
                        }
                    case .failure(let error):
                        print("EnesTalhaUcarResponse")
                        print(response)
                        self.errorMessage = "Hata: \(error.localizedDescription)"
                        print(self.errorMessage as Any)
                    }
                }
            }
        
    }
    
    func fetchQuizResult(quizId: String) {
        let url = Utilities.Constants.Endpoints.Quiz.quizResultForQuiz
        
        // Optional token'ı güvenli bir şekilde unwrap ediyoruz
        guard let token = Utilities.shared.getUserDetailsFromUserDefaults()["token"] else {
            self.errorMessage = "Hata: Token bulunamadı."
            self.isLoading = false
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: String] = ["quizId": quizId]
        
        isLoading = true
        errorMessage = nil
        
        AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .responseString { response in
                print("Sunucudan gelen cevap : \(response)")
            }
            .responseDecodable(of: QuizResultForQuizResponse.self) { response in
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch response.result {
                    case .success(let data):
                        self.quizResult = data.data?.formattedQuizResult
                    case .failure(let error):
                        self.errorMessage = "Hata: \(error.localizedDescription)"
                        print(self.errorMessage as Any)
                    }
                }
            }
    }
}
