//
//  ProfileEditView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 6.09.2024.
//

import SwiftUI
import PhotosUI
import FirebaseStorage
import FirebaseFirestore

@MainActor
private class ProfileEditViewModel : ObservableObject {
    @Published private(set) var user : DBUser? = nil
    @State private var uploadStatusMessage: String = ""
    @State var isLoading : Bool = true
    @Published var profileImage: UIImage? = nil // Profil resmi burada tutulacak
    
    
    // Current User'ın datasını indirme
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
        
        // Firestore'dan profil fotoğrafı URL'sini al
        if let user = user, let profilePhotoUrl = user.profilePhotoUrl {
            // URL'den resmi indir
            await downloadImageFromFirebase(urlString: profilePhotoUrl)
            
        }
    }
    // Fotoğrafı Firebase e gönderme
    func uploadImageToFirebase(image: UIImage, completion: @escaping () -> Void) {
            guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }

            let storageRef = Storage.storage().reference().child("profileImages/\(UUID().uuidString).jpg")
            storageRef.putData(imageData, metadata: nil) { metadata, error in
                if let error = error {
                    self.uploadStatusMessage = "Resim yükleme hatası: \(error.localizedDescription)"
                    completion() // Yükleme tamamlandığında bile hata olsa bile çağır
                    return
                }

                storageRef.downloadURL { url, error in
                    if let error = error {
                        self.uploadStatusMessage = "URL alma hatası: \(error.localizedDescription)"
                        completion() // Yükleme tamamlandığında bile hata olsa bile çağır
                        return
                    }

                    if let url = url {
                        self.saveImageUrlToFirestore(imageUrl: url.absoluteString)
                    }
                    completion() // Yükleme tamamlandığında başarılıysa çağır
                }
            }
        }
    // Fotoğrafın URL'ini Firestore'da tutma
    func saveImageUrlToFirestore(imageUrl: String) {
        let db = Firestore.firestore()
        guard let userId = user?.userId else {
            self.uploadStatusMessage = "Kullanıcı ID bulunamadı."
            return
        }
        
        // Firestore'a URL'yi kaydet
        
        db.collection("users").document(userId).setData(["profile_photo_url": imageUrl], merge: true) { error in
            if let error = error {
                self.uploadStatusMessage = "Veritabanı hatası: \(error.localizedDescription)"
            } else {
                self.uploadStatusMessage = "Resim başarıyla kaydedildi!"
            }
        }
        
    }
    // User'ın fotoğrafını firebase'den indirme
    func downloadImageFromFirebase(urlString: String) async {
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                // İndirilen resmi atama
                self.profileImage = image
                
            }
        } catch {
            print("Resim indirme hatası: \(error)")
        }
    }
    // Önceki fotoğrafı silme
    func deleteOldImageFromFirebase(urlString: String) {
        let storageRef = Storage.storage().reference(forURL: urlString)
        
        // Firebase Storage'dan eski resmi sil
        storageRef.delete { error in
            if let error = error {
                print("Eski resmi silerken hata oluştu: \(error.localizedDescription)")
            } else {
                print("Eski resim başarıyla silindi.")
            }
        }
    }
    // Kullanıcının ismini kaydetme
    func saveUsersName(name : String) {
        let db = Firestore.firestore()
        guard let userId = user?.userId else {
            self.uploadStatusMessage = "Kullanıcı ID bulunamadı."
            return
        }
        
        db.collection("users").document(userId).setData(["name": name], merge: true) { error in
            if let error = error {
                self.uploadStatusMessage = "Veritabanı hatası: \(error.localizedDescription)"
            } else {
                self.uploadStatusMessage = "Kullanıcının ismi başarıyla kaydedildi!"
            }
        }
        
    }
}

struct ProfileEditView: View {
    @StateObject private var viewModel = ProfileEditViewModel()
    @Binding var isSuccess : Bool
    @State private var avatarImage : UIImage?
    @State private var photosPickerItem : PhotosPickerItem?
    @State private var userName : String = ""
    @State private var isUploading: Bool = false // Yükleme durumunu takip etmek için
   
    
    var body: some View {
        VStack {
            NavigationStack {
                    VStack {
                        if let user = viewModel.user {
                            ZStack {
                                PhotosPicker(selection : $photosPickerItem, matching: .images) {
                                    Image(uiImage: avatarImage ?? viewModel.profileImage ?? UIImage(resource: .personIcon))
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 100, height: 100)
                                        .clipShape(Circle())
                                }
                                
                                if isUploading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle())
                                        .frame(width: 40, height: 40) // Daire boyutu
                                }
                            }
                            
                            TextField("\(user.name ?? "default")", text: $userName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                        }
                        
                        Button("Save") {
                            if let image = avatarImage {
                                isUploading = true
                                viewModel.uploadImageToFirebase(image: image) {
                                    isUploading = false
                                }
                                
                            }
                            viewModel.saveUsersName(name: userName)
                        }
                    }.task {
                        try? await viewModel.loadCurrentUser()
                    }
                    .onChange(of: photosPickerItem) { oldValue, newValue in
                        Task {
                            if let photosPickerItem,
                               let data = try? await photosPickerItem.loadTransferable(type: Data.self) {
                                if let image = UIImage(data: data) {
                                    avatarImage = image
                                }
                            }
                        }
                    }
                
            }
        }
    }
    
    
}

#Preview {
    ProfileEditView(isSuccess: .constant(false))
}


