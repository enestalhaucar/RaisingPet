//
//  AlbumSettingsView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 21.10.2024.
//

import SwiftUI
import PhotosUI

enum ChangePhotos {
    case automatic
    case tapToChange
}

struct AlbumSettingsView: View {
    @State var items : [AlbumWidget] = [
        AlbumWidget(backgroundImage: [], size: .small),
        AlbumWidget(backgroundImage: [], size: .medium),
        AlbumWidget(backgroundImage: [], size: .large)
    ]
    @State var selectedIndex : Int = 0
    @State private var photosPickerItems: [PhotosPickerItem] = []
    @State private var images: [UIImage] = []
    
    
    
    
    @State var colorSet : [Color] = [.black, .blue, .brown, .white, .cyan, .gray, .green, .indigo, .mint, .orange, .pink, .teal, .yellow]
    @State private var showColorPicker: Bool = false
    @State private var selectedColor: Color = .clear
    @State private var frameColor : Color = .black
    
    
    //    @State private var selectedChangePhoto : ChangePhotos = .automatic
    
    @State private var showFrequency = false
    
    @State private var selectedChangeFrequency = "15 Minute"
    
    @State private var stepValue = 5
    
    private func removeImage(at index: Int) {
        images.remove(at: index)
    }
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                WidgetSettingsBackground()
                VStack {
                    TabView(selection : $selectedIndex) {
                        ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                            AlbumWidgetPreviewDesign(item: item)
                                .tag(index)
                        }
                    }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                        .frame(height: selectedIndex == items.count - 1 ? 450 : 250)
                        .animation(.bouncy(duration: 0.5), value: selectedIndex)
                        .background(Color.gray.gradient.opacity(0.1))
                    
                    ScrollView {
                        VStack {
                            VStack {
                                HStack {
                                    Text("Photo Frame").bold()
                                    Spacer()
                                    if items.first?.frameColor != nil {
                                        Stepper("", value: $stepValue, in: 1...12)
                                            .onChange(of: stepValue) { _ in
                                                for index in items.indices {
                                                    items[index].lineWidth = CGFloat(stepValue)
                                                }
                                            }
                                    }
                                }.padding()
                                
                                ScrollView(.horizontal) {
                                    HStack {
                                        
                                        Button {
                                            for index in items.indices {
                                                items[index].frameColor = nil
                                            }
                                        } label: {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 15)
                                                    .frame(width: 80, height: 50)
                                                    .foregroundStyle(.ultraThickMaterial)
                                                Text("None").foregroundStyle(.gray)
                                            }
                                        }
                                        
                                        Button {
                                            showColorPicker = true
                                        } label: {
                                            RoundedRectangle(cornerRadius: 5)
                                                .frame(width: 50,height: 50)
                                                .foregroundStyle(AngularGradient(colors: [.yellow, .red, .blue], center: .center, startAngle: .zero, endAngle: .degrees(360)))
                                        }
                                        
                                        ForEach(colorSet, id: \.self) { item in
                                            RoundedRectangle(cornerRadius: 5).frame(width: 50, height: 50)
                                                .foregroundStyle(item)
                                                .onTapGesture {
                                                    selectedColor = item
                                                    for index in items.indices {
                                                        items[index].frameColor = selectedColor
                                                    }
                                                    
                                                }
                                                .overlay {
                                                    if item == .white {
                                                        RoundedRectangle(cornerRadius: 5)
                                                            .stroke(.gray.opacity(0.2), lineWidth: 1)
                                                    }
                                                    if selectedColor == item { // Eğer bu renk seçildiyse stroke ekle
                                                        RoundedRectangle(cornerRadius: 5)
                                                            .stroke(.orange, lineWidth: 2)
                                                    }
                                                }
                                        }
                                        
                                    }
                                }.padding(.horizontal).padding(.bottom)
                                    .scrollIndicators(.hidden)
                                    .sheet(isPresented: $showColorPicker) {
                                        ColorPickerView(title: "Color Picker", selectedColor: frameColor, didSelectColor: { color in
                                            for index in items.indices {
                                                items[index].frameColor = color
                                            }
                                        })
                                        .padding(.top, 8)
                                        .background(.white)
                                        .presentationDetents([.height(640)])
                                    }
                                
                                
                            }
                            
                            Divider()
                            
                            VStack {
                                HStack {
                                    Text("Photos \(images.count) / 10").bold()
                                    Spacer()
                                }.padding(.horizontal).padding(.top)
                                
                                
                                
                                
                                // PHOTOS
                                
                                ScrollView(.horizontal) {
                                    HStack {
                                        PhotosPicker(selection: $photosPickerItems, matching: .images) {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 15)
                                                    .foregroundStyle(.gray.gradient.opacity(0.3))
                                                    .frame(width: 80, height: 50)
                                                Image(systemName: "photo")
                                            }
                                            
                                        }
                                        
                                        ForEach(images.indices, id: \.self) { index in
                                            ZStack(alignment: .topTrailing) {
                                                Image(uiImage: images[index])
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 50, height: 50)
                                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                                
                                                Button {
                                                    removeImage(at: index)
                                                } label: {
                                                    Image(systemName: "xmark.circle.fill")
                                                        .resizable()
                                                        .frame(width: 20, height: 20)
                                                        .foregroundStyle(.red)
                                                        .offset(x: 8, y: -8)
                                                }
                                            }
                                            
                                        }
                                    }.frame(height: 70)
                                }.padding(.horizontal).scrollIndicators(.hidden)
                                
                                //                                HStack {
                                //                                    Text("Change Photos").bold()
                                //                                    Spacer()
                                //                                }.padding()
                                //                                // Change Photos
                                //                                HStack {
                                //                                    // AUTO
                                //                                    Button {
                                //                                        selectedChangePhoto = .automatic
                                //                                    } label: {
                                //                                        ZStack {
                                //                                            RoundedRectangle(cornerRadius: 15)
                                //                                                .foregroundStyle(selectedChangePhoto == .automatic ? Color.blue.opacity(0.7) : Color.gray.opacity(0.15))
                                //                                                .frame(height: 50)
                                //
                                //                                            Text("Automatic").bold()
                                //                                                .foregroundStyle(selectedChangePhoto == .automatic ? .white : .gray.opacity(0.4))
                                //                                        }
                                //                                    }
                                //                                    // TAP TO CHANGE
                                //                                    Button {
                                //                                        selectedChangePhoto = ChangePhotos.tapToChange
                                //                                    } label: {
                                //                                        ZStack {
                                //                                            RoundedRectangle(cornerRadius: 15)
                                //                                                .foregroundStyle(selectedChangePhoto == .tapToChange ? Color.blue.opacity(0.7) : Color.gray.opacity(0.15))
                                //                                                .frame(height: 50)
                                //
                                //                                            Text("Tap To Change").bold().foregroundStyle(selectedChangePhoto == .tapToChange ? .white : .gray.opacity(0.4))
                                //                                        }
                                //                                    }
                                //
                                //                                }.padding(.horizontal)
                                
                                
                                // Change Frequency
                                HStack {
                                    Text("Change Frequency").bold()
                                    Spacer()
                                    Button {
                                        showFrequency.toggle()
                                    } label: {
                                        HStack {
                                            Text(selectedChangeFrequency)
                                            Image(systemName : "arrow.forward")
                                        }.foregroundStyle(.gray.opacity(0.7))
                                    }
                                }.padding()
                                
                                
                                
                                
                                
                                
                                
                            }.onChange(of: photosPickerItems) { _ in
                                Task {
                                    for item in photosPickerItems {
                                        if let data = try? await item.loadTransferable(type: Data.self) {
                                            if let image = UIImage(data: data) {
                                                images.append(image)
                                            }
                                        }
                                    }
                                    photosPickerItems.removeAll()
                                    
                                    var imageArray : [Image] {
                                        convertUIImageArrayToImageArray(uiImages: images)
                                    }
                                    
                                    for index in items.indices {
                                        items[index].backgroundImage = imageArray
                                    }
                                    
                                }
                            }
                            
                            
                            
                            
                        }
                        
                    }
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Text("Save")
                            .bold()
                            .frame(width: 100, height: 40)
                            .background(.blue.opacity(0.3))
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                }.sheet(isPresented: $showFrequency) {
                    ChangeFrequencyView(selectedFrequency: $selectedChangeFrequency)
                        .presentationDetents([.fraction(0.3)])
                }
            }.navigationTitle("Album Widget Settings")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
    func convertUIImageArrayToImageArray(uiImages: [UIImage]) -> [Image] {
        return uiImages.map { Image(uiImage: $0) }
    }
}

#Preview {
    AlbumSettingsView()
}


struct ChangeFrequencyView : View {
    @State private var frequencyList : [String] = ["15 Minute","30 Minute","1 Hour","2 Hour","3 Hour","4 Hour","6 Hour","12 Hour", "1 Day"]
    @Environment(\.dismiss) var dismiss
    @Binding var selectedFrequency : String
    var body: some View {
        NavigationStack {
            Picker("Picker", selection: $selectedFrequency) {
                ForEach(frequencyList, id: \.self) {
                    Text($0)
                }
            }.pickerStyle(.wheel)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }
                }
        }
    }
}
