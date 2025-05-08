//
//  CurrentUserViewModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 5.05.2025.
//

import Combine
import Foundation

final class CurrentUserViewModel: ObservableObject {
    @Published var user: GetMeUser?      // geçerli kullanıcı
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    func refresh() {
        isLoading = true
        Utilities.shared.fetchCurrentUser { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let me):
                    self?.user = me
                case .failure(let err):
                    self?.errorMessage = err.localizedDescription
                }
            }
        }
    }
}
