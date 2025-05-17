// This file is now deprecated and should be removed
// All functionality has been migrated to repository pattern implementations.
// 
// Mark this file for deletion in future refactoring.

/*
import Alamofire
import Foundation

extension Utilities {
    // This method has been replaced by UserProfileRepositoryImpl.getCurrentUser()
    // Keep temporarily for backward compatibility
    @available(*, deprecated, message: "Use UserProfileRepository.getCurrentUser() instead")
    func fetchCurrentUser(completion: @escaping (Result<GetMeUser, AFError>) -> Void) {
        let url = Constants.Endpoints.Auth.me
        let token = getUserDetailsFromUserDefaults()["token"] ?? ""
        print("Fetched Token: \(token)")
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: GetMeResponseModel.self) { response in
                switch response.result {
                case .success(let wrapper):
                    guard let data = wrapper.data else { return }
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
*/
