//
//  ProfileEditView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 6.09.2024.
//

import SwiftUI
import PhotosUI

struct ProfileEditView: View {
    @StateObject private var viewModel = ProfileEditViewModel()
    @Binding var isSuccess: Bool
    @Environment(\.dismiss) var dismiss
    @State private var profileImage: UIImage? = nil
    @State private var profileImageData: Data? = nil
    private let placeholderImage = UIImage(named: "placeholder")
    @State private var isPhotoPickerPresented = false
    @State private var showAlert = false
    @State private var isLoading = false
    
    // User details for display only
    @State private var userDetails: [String: String] = [:]

    var body: some View {
        ScrollView {
            ZStack {
                Color("mainbgColor").ignoresSafeArea()

                VStack(spacing: 16) {
                    // User profile section
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .foregroundStyle(.white)

                        VStack(spacing: 30) {
                            // Profile image display
                            ZStack {
                                // Background circle
                                Circle()
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                                    .frame(width: 120, height: 120)
                                    .shadow(radius: 5)
                                
                                // Profile image
                                if let image = profileImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 120, height: 120)
                                        .clipShape(Circle())
                                } else if isLoading {
                                    // Show loading spinner when fetching image
                                    ProgressView()
                                        .frame(width: 120, height: 120)
                                } else {
                                    // Default placeholder
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 120, height: 120)
                                        .foregroundColor(.blue.opacity(0.7))
                                        .clipShape(Circle())
                                }
                                
                                // Edit button overlay
                                VStack {
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        Button(action: {
                                            isPhotoPickerPresented = true
                                        }) {
                                            Image(systemName: "pencil.circle.fill")
                                                .resizable()
                                                .frame(width: 30, height: 30)
                                                .foregroundColor(.blue)
                                                .background(Circle().fill(Color.white))
                                        }
                                    }
                                }
                                .frame(width: 110, height: 110)
                            }
                            
                            // User name display
                            Text("\(userDetails["firstname"] ?? "User") \(userDetails["surname"] ?? "")")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        .padding(.vertical, 30)
                    }
                    .frame(maxHeight: UIScreen.main.bounds.size.height * 0.45)

                    // Save button
                    Button(action: {
                        Task {
                            await saveProfilePhoto()
                        }
                    }) {
                        HStack {
                            Text("profile_edit_save_changes".localized())
                                .font(.headline)
                            
                            if viewModel.isLoading {
                                ProgressView()
                                    .padding(.leading, 5)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(viewModel.isLoading ? Color.gray : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .disabled(viewModel.isLoading || profileImage == nil)
                }
                .padding()
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("profile_edit_error_title".localized()),
                    message: Text(viewModel.errorMessage ?? "profile_edit_unknown_error".localized()),
                    dismissButton: .default(Text("profile_edit_alert_ok".localized()))
                )
            }
            .onAppear {
                loadUserData()
            }
        }
        .navigationTitle("profile_edit_photo_title".localized())
        .sheet(isPresented: $isPhotoPickerPresented) {
            PhotoPicker(selectedImage: $profileImage)
        }
    }
    
    private func loadUserData() {
        // Load user details from UserDefaults
        userDetails = Utilities.shared.getUserDetailsFromUserDefaults()
        
        // Try to load existing profile photo
        if let photoData = UserDefaults.standard.data(forKey: "userProfilePhoto"),
           let image = UIImage(data: photoData) {
            profileImage = image
        } else if let photoURL = userDetails["photoURL"], !photoURL.isEmpty {
            // If we have a URL but no cached image, fetch it
            loadProfilePhotoFromURL(photoURL)
        }
    }
    
    private func loadProfilePhotoFromURL(_ photoURL: String) {
        isLoading = true
        
        Task {
            do {
                let imageData = try await viewModel.getUserProfileImage(photoURL: photoURL)
                if let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        profileImage = image
                        // Cache the downloaded image
                        UserDefaults.standard.set(imageData, forKey: "userProfilePhoto")
                        isLoading = false
                    }
                }
            } catch {
                print("Failed to load profile image: \(error)")
                DispatchQueue.main.async {
                    isLoading = false
                }
            }
        }
    }
    
    private func saveProfilePhoto() async {
        guard let profileImage = profileImage else { return }
        
        await viewModel.updateProfile(photo: profileImage)
        
        if viewModel.isSuccess {
            // Save the image to UserDefaults so it's immediately available elsewhere
            if let imageData = profileImage.jpegData(compressionQuality: 0.8) {
                UserDefaults.standard.set(imageData, forKey: "userProfilePhoto")
            }
            
            // Set success status for the parent view
            isSuccess = true
            
            // Post a notification that the profile has been updated
            // This allows other views to refresh their state
            NotificationCenter.default.post(name: .profileImageUpdated, object: nil)
            
            // Dismiss this view to return to profile
            DispatchQueue.main.async {
                dismiss()
            }
        } else if viewModel.errorMessage != nil {
            showAlert = true
        }
    }
}

struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoPicker

        init(_ parent: PhotoPicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) else { return }

            itemProvider.loadObject(ofClass: UIImage.self) { image, _ in
                DispatchQueue.main.async {
                    self.parent.selectedImage = image as? UIImage
                }
            }
        }
    }
}

#Preview {
    ProfileEditView(isSuccess: .constant(false))
}
