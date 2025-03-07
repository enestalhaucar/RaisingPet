//
//  ProfileEditView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 6.09.2024.
//

import SwiftUI
import PhotosUI


@MainActor
private class ProfileEditViewModel : ObservableObject {
    
}

struct ProfileEditView: View {
    @StateObject private var viewModel = ProfileEditViewModel()
    @Binding var isSuccess : Bool
    var copied : String = "Copied"
    @State private var userDetails: [String: String] = [:]
    @State private var profileImage: UIImage? = nil
    private let placeholderImage = UIImage(named: "placeholder")
    @State private var isPhotoPickerPresented = false
    
    @State private var showCopiedMessage = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("mainbgColor").ignoresSafeArea()
                
                VStack {
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
                            
                            VStack(spacing: 10) {
                                Text("Enes Talha Uçar")
                                    .font(.nunito(.medium, .title222))
                                    .fontWeight(.heavy)
                                
                                HStack {
                                    Image(systemName: "document.on.document")
                                        .foregroundStyle(.black)
                                    
                                    Text(showCopiedMessage ? copied : userDetails["friendTag"] ?? "-")
                                        .font(.nunito(.semiBold, .body16))
                                        .foregroundStyle(.blue)
                                        .onTapGesture {
                                            UIPasteboard.general.string = userDetails["friendTag"] ?? "It could not pasted on pasteboard."
                                            withAnimation {
                                                showCopiedMessage = true
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                withAnimation {
                                                    showCopiedMessage = false
                                                }
                                            }
                                        }
                                }
                            }
                        }
                        
                    }.frame(maxHeight: UIScreen.main.bounds.size.height * 0.3)
                    
                    
                    Button(action: {
                        isPhotoPickerPresented = true
                    }) {
                        Text("Fotoğraf Yükle")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                    
                    Spacer()
                }.padding()
                    .sheet(isPresented: $isPhotoPickerPresented) {
                        PhotoPicker(selectedImage: $profileImage)
                    }
            }.onAppear {
                userDetails = Utilities.shared.getUserDetailsFromUserDefaults()
            }
        }
    }
    
    
}

#Preview {
    ProfileEditView(isSuccess: .constant(false))
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
