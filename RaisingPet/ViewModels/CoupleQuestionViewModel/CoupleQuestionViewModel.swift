//
//  CoupleQuestionViewModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 4.02.2025.
//

import Foundation
import Alamofire
class CoupleQuestionViewModel: ObservableObject {
    @Published var quizTitles : [String] = []
    @Published var isLoading = false
    @Published var errorMessage : String?
    
    func fetchQuizzes() {
        let url = Utilities.Constants.Endpoints.Quiz.getAllQuizes
        
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
                        self.quizTitles = data.data.data.map { $0.title }
                    case .failure(let error):
                        self.errorMessage = "Hata: \(error.localizedDescription)"
                    }
                }
            }
    }
    
}
