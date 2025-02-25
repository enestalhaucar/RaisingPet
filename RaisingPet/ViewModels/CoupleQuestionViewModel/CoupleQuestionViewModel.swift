//
//  CoupleQuestionViewModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 4.02.2025.
//

import Foundation
import Alamofire
class CoupleQuestionViewModel: ObservableObject {
    @Published var quiz : [QuizModel] = []
    @Published var isLoading : Bool = false
    @Published var errorMessage : String?
    @Published var selectedQuiz: GetQuizResponseModel.QuizDetailModel?
    @Published var startQuizResponse : QuizResultData?
    
    func fetchQuizzes() {
        let url = Utilities.Constants.Endpoints.Quiz.getUserQuizes
        
        let headers : HTTPHeaders = [
            "Authorization": "Bearer \(Utilities.shared.getUserDetailsFromUserDefaults()["token"] ?? "")",
            "Content-Type": "application/json"
        ]
        isLoading = true
        errorMessage = nil
        
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: GetAllQuizesResponseModel.self) { response in
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch response.result {
                    case .success(let data):
                        print(data)
                        self.quiz = data.data
                    case .failure(let error):
                        self.errorMessage = "Hata: \(error.localizedDescription)"
                    }
                }
            }

    }
    
    
    
    
    func fetchQuizDetails(quizId: String) {
        let url = Utilities.Constants.Endpoints.Quiz.getQuizById.replacingOccurrences(of: ":id", with: quizId)
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Utilities.shared.getUserDetailsFromUserDefaults()["token"] ?? "")",
            "Content-Type": "application/json"
        ]
        
        isLoading = true
        errorMessage = nil
        
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: GetQuizResponseModel.self) { response in
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch response.result {
                    case .success(let data):
                        self.selectedQuiz = data.data.data
                        print(self.selectedQuiz as Any)
                    case .failure(let error):
                        self.errorMessage = "Hata: \(error.localizedDescription)"
                        print(self.errorMessage as Any)
                    }
                }
            }
    }
    
    func startQuiz() {
        let url = Utilities.Constants.Endpoints.Quiz.startQuizResult
        
        let headers : HTTPHeaders = [
            "Authorization": "Bearer \(Utilities.shared.getUserDetailsFromUserDefaults()["token"] ?? "")",
            "Content-Type": "application/json"
        ]
        
        isLoading = true
        errorMessage = nil
        
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: QuizResultData.self) { response in
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch response.result {
                    case .success(let result):
                        self.startQuizResponse = result
                    case .failure(let error):
                        self.errorMessage = "Hata : \(error.localizedDescription)"
                        print(self.errorMessage as Any)
                    }
                }
                
            }
        
    }
    
}
