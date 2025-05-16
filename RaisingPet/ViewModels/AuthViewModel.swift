import Foundation
import Combine
import SwiftUI

class AuthViewModel: ObservableObject {
    // Published properties
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isAuthenticated = false
    @Published var user: GetMeResponseModel?
    
    // Repositories
    private let authRepository: AuthRepository
    
    // Cancellables
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(authRepository: AuthRepository = RepositoryProvider.shared.authRepository) {
        self.authRepository = authRepository
        
        // Check if user is already authenticated
        if UserDefaults.standard.string(forKey: "authToken") != nil {
            loadUserData()
        }
    }
    
    // MARK: - Authentication Methods
    func login(email: String, password: String) {
        isLoading = true
        errorMessage = nil
        
        Task { @MainActor in
            do {
                let response = try await authRepository.login(email: email, password: password)
                
                // Save authentication token
                UserDefaults.standard.set(response.token, forKey: "authToken")
                
                // Load user data
                loadUserData()
                
                isLoading = false
                isAuthenticated = true
            } catch let error as NetworkError {
                isLoading = false
                errorMessage = error.errorMessage
            } catch {
                isLoading = false
                errorMessage = "Bilinmeyen bir hata oluştu"
            }
        }
    }
    
    func signup(firstName: String, lastName: String, email: String, password: String, phoneNumber: String) {
        isLoading = true
        errorMessage = nil
        
        Task { @MainActor in
            do {
                let response = try await authRepository.signup(
                    firstName: firstName,
                    lastName: lastName,
                    email: email,
                    password: password,
                    phoneNumber: phoneNumber
                )
                
                // Automatically login after signup
                login(email: email, password: password)
            } catch let error as NetworkError {
                isLoading = false
                errorMessage = error.errorMessage
            } catch {
                isLoading = false
                errorMessage = "Bilinmeyen bir hata oluştu"
            }
        }
    }
    
    func loadUserData() {
        isLoading = true
        errorMessage = nil
        
        Task { @MainActor in
            do {
                let userData = try await authRepository.getMe()
                
                // Save user data
                user = userData
                
                // Save user details in UserDefaults
                if let user = userData.data {
                    UserDefaults.standard.set(user.firstname, forKey: "userFirstname")
                    UserDefaults.standard.set(user.surname, forKey: "userSurname")
                    UserDefaults.standard.set(user.email, forKey: "userEmail")
                    UserDefaults.standard.set(user.friendTag, forKey: "userFriendTag")
                    UserDefaults.standard.set(user.id, forKey: "userId")
                    UserDefaults.standard.set(user.phoneNumber, forKey: "userPhoneNumber")
                }
                
                isLoading = false
                isAuthenticated = true
            } catch let error as NetworkError {
                isLoading = false
                errorMessage = error.errorMessage
                
                // Handle unauthorized - clear token
                if case .unauthorized = error {
                    logout()
                }
            } catch {
                isLoading = false
                errorMessage = "Bilinmeyen bir hata oluştu"
            }
        }
    }
    
    func updateProfile(firstName: String? = nil, lastName: String? = nil, email: String? = nil, phoneNumber: String? = nil) {
        isLoading = true
        errorMessage = nil
        
        Task { @MainActor in
            do {
                let updatedUser = try await authRepository.updateMe(
                    firstName: firstName,
                    lastName: lastName,
                    email: email,
                    phoneNumber: phoneNumber
                )
                
                // Update user data
                user = updatedUser
                
                // Update UserDefaults
                if let user = updatedUser.data {
                    if firstName != nil { UserDefaults.standard.set(user.firstname, forKey: "userFirstname") }
                    if lastName != nil { UserDefaults.standard.set(user.surname, forKey: "userSurname") }
                    if email != nil { UserDefaults.standard.set(user.email, forKey: "userEmail") }
                    if phoneNumber != nil { UserDefaults.standard.set(user.phoneNumber, forKey: "userPhoneNumber") }
                }
                
                isLoading = false
            } catch let error as NetworkError {
                isLoading = false
                errorMessage = error.errorMessage
            } catch {
                isLoading = false
                errorMessage = "Bilinmeyen bir hata oluştu"
            }
        }
    }
    
    func logout() {
        // Clear authentication data
        UserDefaults.standard.removeObject(forKey: "authToken")
        UserDefaults.standard.removeObject(forKey: "userFirstname")
        UserDefaults.standard.removeObject(forKey: "userSurname")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        UserDefaults.standard.removeObject(forKey: "userFriendTag")
        UserDefaults.standard.removeObject(forKey: "userId")
        UserDefaults.standard.removeObject(forKey: "userPhoneNumber")
        
        // Update state
        isAuthenticated = false
        user = nil
    }
} 