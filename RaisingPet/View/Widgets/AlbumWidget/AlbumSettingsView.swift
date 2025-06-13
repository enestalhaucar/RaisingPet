//
//  AlbumSettingsView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 21.10.2024.
//
import SwiftUI
import PhotosUI

// struct AlbumSettingsView: View {
//    @State private var photosPickerItems: [PhotosPickerItem] = []
//    @State private var images: [UIImage] = []
//    @State private var selectedIndex: Int = 0
//    @State private var frameColor: Color = .black
//    @State private var lineWidth: CGFloat = 5
//    @State private var showColorPicker: Bool = false
//    @State private var selectedChangeFrequency: String = "15 Minute"
//    @State private var showFrequency: Bool = false
//    
//    private let colorSet: [Color] = [.black, .blue, .brown, .white, .cyan, .gray, .green, .indigo, .mint, .orange, .pink, .teal, .yellow]
//    
//    var body: some View {
//        NavigationStack {
//            ZStack {
//                Color(.systemGray6).ignoresSafeArea()
//                VStack {
//                    TabView(selection: $selectedIndex) {
//                        AlbumWidgetPreviewDesign(item: previewItem(size: .small)).tag(0)
//                        AlbumWidgetPreviewDesign(item: previewItem(size: .medium)).tag(1)
//                        AlbumWidgetPreviewDesign(item: previewItem(size: .large)).tag(2)
//                    }
//                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
//                    .frame(height: selectedIndex == 2 ? 450 : 250)
//                    .animation(.bouncy(duration: 0.5), value: selectedIndex)
//                    .background(Color.gray.gradient.opacity(0.1))
//                    
//                    ScrollView {
//                        VStack(spacing: 15) {
//                            // Frame Color Section
//                            VStack {
//                                HStack {
//                                    Text("Photo Frame").bold()
//                                    Spacer()
//                                    Stepper("", value: Binding(get: { Int(lineWidth) }, set: { lineWidth = CGFloat($0) }), in: 1...12)
//                                }.padding()
//                                
//                                ScrollView(.horizontal) {
//                                    HStack {
//                                        Button {
//                                            frameColor = .clear // None seçeneği
//                                        } label: {
//                                            ZStack {
//                                                RoundedRectangle(cornerRadius: 15)
//                                                    .frame(width: 80, height: 50)
//                                                    .foregroundStyle(.ultraThickMaterial)
//                                                Text("None").foregroundStyle(.gray)
//                                            }
//                                        }
//                                        
//                                        Button {
//                                            showColorPicker = true
//                                        } label: {
//                                            RoundedRectangle(cornerRadius: 5)
//                                                .frame(width: 50, height: 50)
//                                                .foregroundStyle(AngularGradient(colors: [.yellow, .red, .blue], center: .center))
//                                        }
//                                        
//                                        ForEach(colorSet, id: \.self) { color in
//                                            RoundedRectangle(cornerRadius: 5)
//                                                .frame(width: 50, height: 50)
//                                                .foregroundStyle(color)
//                                                .overlay {
//                                                    if color == .white {
//                                                        RoundedRectangle(cornerRadius: 5)
//                                                            .stroke(.gray.opacity(0.2), lineWidth: 1)
//                                                    }
//                                                    if frameColor == color {
//                                                        RoundedRectangle(cornerRadius: 5)
//                                                            .stroke(.orange, lineWidth: 2)
//                                                    }
//                                                }
//                                                .onTapGesture {
//                                                    frameColor = color
//                                                }
//                                        }
//                                    }
//                                }
//                                .padding(.horizontal)
//                                .scrollIndicators(.hidden)
//                                .sheet(isPresented: $showColorPicker) {
////                                    ColorPickerView(title: "Color Picker", selectedColor: frameColor) { color in
////                                        frameColor = color
////                                    }
//                                    .presentationDetents([.height(640)])
//                                }
//                            }
//                            
//                            Divider()
//                            
//                            // Photos Section
//                            VStack {
//                                HStack {
//                                    Text("Photos \(images.count) / 10").bold()
//                                    Spacer()
//                                }.padding(.horizontal).padding(.top)
//                                
//                                ScrollView(.horizontal) {
//                                    HStack {
//                                        PhotosPicker(selection: $photosPickerItems, maxSelectionCount: 10, matching: .images) {
//                                            ZStack {
//                                                RoundedRectangle(cornerRadius: 15)
//                                                    .foregroundStyle(.gray.gradient.opacity(0.3))
//                                                    .frame(width: 80, height: 50)
//                                                Image(systemName: "photo")
//                                            }
//                                        }
//                                        
//                                        ForEach(images.indices, id: \.self) { index in
//                                            ZStack(alignment: .topTrailing) {
//                                                Image(uiImage: images[index])
//                                                    .resizable()
//                                                    .aspectRatio(contentMode: .fill)
//                                                    .frame(width: 50, height: 50)
//                                                    .clipShape(RoundedRectangle(cornerRadius: 10))
//                                                Button {
//                                                    images.remove(at: index)
//                                                } label: {
//                                                    Image(systemName: "xmark.circle.fill")
//                                                        .resizable()
//                                                        .frame(width: 20, height: 20)
//                                                        .foregroundStyle(.red)
//                                                        .offset(x: 8, y: -8)
//                                                }
//                                            }
//                                        }
//                                    }.frame(height: 70)
//                                }.padding(.horizontal).scrollIndicators(.hidden)
//                                
//                                // Change Frequency
//                                HStack {
//                                    Text("Change Frequency").bold()
//                                    Spacer()
//                                    Button {
//                                        showFrequency.toggle()
//                                    } label: {
//                                        HStack {
//                                            Text(selectedChangeFrequency)
//                                            Image(systemName: "arrow.forward")
//                                        }.foregroundStyle(.gray.opacity(0.7))
//                                    }
//                                }.padding()
//                            }
//                            .onChange(of: photosPickerItems) { _ in
//                                Task {
//                                    var newImages: [UIImage] = []
//                                    for item in photosPickerItems {
//                                        if let data = try? await item.loadTransferable(type: Data.self),
//                                           let image = UIImage(data: data) {
//                                            newImages.append(image)
//                                        }
//                                    }
//                                    images.append(contentsOf: newImages)
//                                    photosPickerItems.removeAll()
//                                }
//                            }
//                        }
//                    }
//                    
//                    Spacer()
//                    
//                    Button(action: saveWidget) {
//                        Text("Save")
//                            .bold()
//                            .frame(width: 100, height: 40)
//                            .background(.blue.opacity(0.3))
//                            .foregroundStyle(.white)
//                            .clipShape(RoundedRectangle(cornerRadius: 10))
//                    }
//                }
//                .sheet(isPresented: $showFrequency) {
////                    ChangeFrequencyView(selectedFrequency: $selectedChangeFrequency)
////                        .presentationDetents([.fraction(0.3)])
//                }
//            }
//            .navigationTitle("Album Widget Settings")
//            .navigationBarTitleDisplayMode(.inline)
//        }
//    }
//    
//    private func previewItem(size: WidgetSize) -> PetiverseWidgetItem {
//        PetiverseWidgetItem(
//            type: .album,
//            title: "",
//            backgroundColor: "gray",
//            textColor: "white",
//            size: size, albumImages: images.map { $0.jpegData(compressionQuality: 1.0)?.base64EncodedString() ?? "" },
//            frameColor: frameColor == .clear ? nil : frameColor.description,
//            lineWidth: lineWidth,
//            changeFrequency: selectedChangeFrequency
//        )
//    }
//    
//    private func saveWidget() {
//        let size: WidgetSize = selectedIndex == 0 ? .small : selectedIndex == 1 ? .medium : .large
//        let widget = PetiverseWidgetItem(
//            type: .album,
//            title: "",
//            backgroundColor: "gray",
//            textColor: "white",
//            albumImages: images.map { $0.jpegData(compressionQuality: 1.0)?.base64EncodedString() ?? "" },
//            size: size,
//            frameColor: frameColor == .clear ? nil : frameColor.description,
//            lineWidth: lineWidth,
//            changeFrequency: selectedChangeFrequency
//        )
//        
//        saveToUserDefaults(widget: widget)
//        WidgetCenter.shared.reloadAllTimelines()
//    }
//    
//    private func saveToUserDefaults(widget: PetiverseWidgetItem) {
//        let suiteName = "group.com.petiverse.widgets"
//        guard let userDefaults = UserDefaults(suiteName: suiteName) else {
//            print("UserDefaults nil döndü!")
//            return
//        }
//        
//        var savedWidgets: [PetiverseWidgetItem] = []
//        if let data = userDefaults.data(forKey: "savedWidgets"),
//           let decoded = try? JSONDecoder().decode([PetiverseWidgetItem].self, from: data) {
//            savedWidgets = decoded
//        }
//        
//        savedWidgets.append(widget)
//        if let encoded = try? JSONEncoder().encode(savedWidgets) {
//            userDefaults.set(encoded, forKey: "savedWidgets")
//            print("Album widget kaydedildi: \(widget.id)")
//        }
//    }
// }
