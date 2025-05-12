//
//  ProfileEditViewModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 10.05.2025.
//

import Foundation
import UIKit
import Alamofire

@MainActor
class ProfileEditViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isSuccess: Bool = false

    private var headers: HTTPHeaders {
        let token = Utilities.shared.getUserDetailsFromUserDefaults()["token"] ?? ""
        return [
            "Authorization": "Bearer \(token)",
            "Content-Type": "multipart/form-data"
        ]
    }

    func updateProfile(firstname: String? = nil, surname: String? = nil, phoneNumber: String? = nil, email: String? = nil, photo: UIImage? = nil) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        let url = Utilities.Constants.Endpoints.Auth.updateMe
        let boundary = UUID().uuidString

        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "PATCH"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(headers["Authorization"]!.replacingOccurrences(of: "Bearer ", with: ""))", forHTTPHeaderField: "Authorization")

        // Multipart body oluştur
        var body = Data()

        // Metin alanlarını ekle (isteğe bağlı)
        if let firstname = firstname {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"firstname\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(firstname)\r\n".data(using: .utf8)!)
        }

        if let surname = surname {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"surname\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(surname)\r\n".data(using: .utf8)!)
        }

        if let phoneNumber = phoneNumber {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"phoneNumber\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(phoneNumber)\r\n".data(using: .utf8)!)
        }

        if let email = email {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"email\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(email)\r\n".data(using: .utf8)!)
        }

        // Fotoğrafı ekle (isteğe bağlı)
        if let photo = photo, let imageData = photo.jpegData(compressionQuality: 0.8) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"photo\"; filename=\"profile.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }

        // Body’nin sonu
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("Profile updated successfully: \(String(data: data, encoding: .utf8) ?? "N/A")")
                isSuccess = true

                // Fotoğrafı UserDefaults’a kaydet
                if let photo = photo, let photoData = photo.jpegData(compressionQuality: 0.8) {
                    UserDefaults.standard.set(photoData, forKey: "userProfilePhoto")
                }

                // Diğer alanları UserDefaults’a güncelle (eğer gönderildiyse)
                if let firstname = firstname {
                    UserDefaults.standard.set(firstname, forKey: "userFirstname")
                }
                if let surname = surname {
                    UserDefaults.standard.set(surname, forKey: "userSurname")
                }
                if let phoneNumber = phoneNumber {
                    UserDefaults.standard.set(phoneNumber, forKey: "userPhoneNumber")
                }
                if let email = email {
                    UserDefaults.standard.set(email, forKey: "userEmail")
                }
            } else {
                errorMessage = "Hata: Profil güncellenemedi - \(response)"
            }
        } catch {
            errorMessage = "Hata: \(error.localizedDescription)"
            print("Update profile error: \(error)")
        }
    }
}
