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
                        }.padding(.vertical)
                    }
                    .frame(maxHeight: UIScreen.main.bounds.size.height * 0.3)

                    // Fotoğraf Yükle Butonu
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
                    .padding()

                    // Kaydet Butonu
                    Button(action: {
                        Task {
                            await viewModel.updateProfile(photo: profileImage)
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
                // UserDefaults’tan fotoğrafı yükle
                if let photoData = UserDefaults.standard.data(forKey: "userProfilePhoto"),
                   let image = UIImage(data: photoData) {
                    profileImage = image
                }
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
