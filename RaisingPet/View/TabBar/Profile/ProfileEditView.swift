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
    private let placeholderImage = UIImage(named: "placeholder")
    @State private var isPhotoPickerPresented = false
    @State private var showAlert = false
    
    // Form fields
    @State private var firstname: String = ""
    @State private var surname: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    
    // Focus states
    @FocusState private var firstnameFocused: Bool
    @FocusState private var surnameFocused: Bool
    @FocusState private var emailFocused: Bool
    @FocusState private var phoneNumberFocused: Bool

    var body: some View {
        ScrollView {
            ZStack {
                Color("mainbgColor").ignoresSafeArea()

                VStack(spacing: 16) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .foregroundStyle(.white)

                        VStack(spacing: 30) {
                            if let image = profileImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                                    .shadow(radius: 10)
                                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                            } else {
                                Image(uiImage: placeholderImage ?? UIImage())
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                                    .shadow(radius: 10)
                                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                            }
                            
                            // Upload Photo Button
                            Button(action: {
                                isPhotoPickerPresented = true
                            }) {
                                Text("profile_edit_upload_photo".localized())
                                    .font(.headline)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }.padding(.vertical)
                    }
                    .frame(maxHeight: UIScreen.main.bounds.size.height * 0.3)

                    // Form fields
                    VStack(spacing: 16) {
                        TextField("First Name", text: $firstname)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 1)
                            .focused($firstnameFocused)
                            .submitLabel(.next)
                            .onSubmit {
                                surnameFocused = true
                            }
                        
                        TextField("Last Name", text: $surname)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 1)
                            .focused($surnameFocused)
                            .submitLabel(.next)
                            .onSubmit {
                                emailFocused = true
                            }
                        
                        TextField("Email", text: $email)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 1)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .focused($emailFocused)
                            .submitLabel(.next)
                            .onSubmit {
                                phoneNumberFocused = true
                            }
                        
                        TextField("Phone Number", text: $phoneNumber)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 1)
                            .keyboardType(.phonePad)
                            .focused($phoneNumberFocused)
                            .submitLabel(.done)
                    }
                    .padding(.horizontal)

                    // Save Button
                    Button(action: {
                        Task {
                            await viewModel.updateProfile(
                                firstname: firstname.isEmpty ? nil : firstname,
                                surname: surname.isEmpty ? nil : surname,
                                phoneNumber: phoneNumber.isEmpty ? nil : phoneNumber,
                                email: email.isEmpty ? nil : email,
                                photo: profileImage
                            )
                            if viewModel.isSuccess {
                                isSuccess = true
                                dismiss()
                            } else if viewModel.errorMessage != nil {
                                showAlert = true
                            }
                        }
                    }) {
                        Text("profile_edit_save_changes".localized())
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(viewModel.isLoading ? Color.gray : Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                    .disabled(viewModel.isLoading)
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
                // Load user details from UserDefaults
                let userDetails = Utilities.shared.getUserDetailsFromUserDefaults()
                firstname = userDetails["firstname"] ?? ""
                surname = userDetails["surname"] ?? ""
                email = userDetails["email"] ?? ""
                phoneNumber = userDetails["phoneNumber"] ?? ""
                
                // Load profile photo
                if let photoData = UserDefaults.standard.data(forKey: "userProfilePhoto"),
                   let image = UIImage(data: photoData) {
                    profileImage = image
                }
            }
            .onTapGesture {
                // Dismiss keyboard when tapping outside text fields
                firstnameFocused = false
                surnameFocused = false
                emailFocused = false
                phoneNumberFocused = false
            }
        }
        .navigationTitle("profile_edit_title".localized())
        .sheet(isPresented: $isPhotoPickerPresented) {
            PhotoPicker(selectedImage: $profileImage)
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
