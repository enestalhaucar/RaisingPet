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
    @Published var quizResultLoaded: Bool = false
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
                    switch response.result {
                    case .success(let data):
                        print(data)
                        self.quiz = data.data
                        self.isLoading = false
                    case .failure(let error):
                        self.errorMessage = "Hata:1 \(error.localizedDescription)"
                        self.isLoading = false
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
                    switch response.result {
                    case .success(let data):
                        self.selectedQuiz = data.data.data
                        print(self.selectedQuiz as Any)
                        self.isLoading = false
                    case .failure(let error):
                        self.errorMessage = "Hata:2 \(error.localizedDescription)"
                        print(self.errorMessage as Any)
                        self.isLoading = false
                    }
                }
            }
    }
    
    func takeQuiz(takeQuizObject: TakeQuizRequest) {
        let url = Utilities.Constants.Endpoints.Quiz.takeQuiz
        isLoading = true
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
        errorMessage = nil
        
        AF.request(url, method: .post, parameters: takeQuizObject, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .responseString { response in
                print("Sunucu Yanıtı : \(String(describing: response.value))")
            }
            .responseDecodable(of: TakeQuizResponse.self) { response in
                DispatchQueue.main.async {
                    switch response.result {
                    case .success(let data):
                        print("TakeQuiz Başarılı: \(data)")
                        self.fetchQuizResult(quizId: quizId) {
                            self.quizResultLoaded = true
                        }
                        self.isLoading = false
                    case .failure(let error):
                        self.errorMessage = "Hata: \(error.localizedDescription)"
                        print(self.errorMessage as Any)
                        self.isLoading = false
                    }
                }
            }
        
    }
    
    func fetchQuizResult(quizId: String, completion : @escaping () -> Void = {}) {
        let url = Utilities.Constants.Endpoints.Quiz.quizResultForQuiz
        isLoading = true
        
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
        
        errorMessage = nil
        
        AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .responseString { response in
                print("Sunucudan gelen cevap : \(response)")
            }
            .responseDecodable(of: QuizResultForQuizResponse.self) { response in
                DispatchQueue.main.async {
                    switch response.result {
                    case .success(let data):
                        self.quizResult = data.data?.formattedQuizResult
                        self.isLoading = false
                        completion()
                    case .failure(let error):
                        self.errorMessage = "Hata: \(error.localizedDescription)"
                        print(self.errorMessage as Any)
                        self.isLoading = false
                        completion()
                    }
                }
            }
    }
}
