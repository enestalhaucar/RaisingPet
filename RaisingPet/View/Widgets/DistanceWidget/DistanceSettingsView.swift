////
////  DistanceSettingsView.swift
////  RaisingPet
////
////  Created by Enes Talha Uçar  on 16.10.2024.
////
//
// import SwiftUI
// import PhotosUI
//
// struct DistanceSettingsView: View {
//    
//    
//    @State private var backgroundColor: Color = .green.opacity(0.3)
//    @State private var textColor: Color = .white
//    @State private var styleIndex : Int = 0
//    @State private var title : String = ""
//    @State var widgetSize : Bool = false
//    @State var selectedIndex : Int = 0
//    @State private var showFriendsList : Bool = false
//    
//    
//    @State var items : [DistanceWidget] = [
//        DistanceWidget(bgSelected: true,backgroundImage: Image("backgroundImageForDistance"), backgroundColor: .green.opacity(0.4), textColor: .white, size: .small, title: "Enes Beyza Relationship"),
//        DistanceWidget(bgSelected: true,backgroundImage: Image("backgroundImageForDistance"), backgroundColor: .green.opacity(0.4), textColor: .white, size: .medium, title: "Enes Beyza Relationship"),
//        DistanceWidget(bgSelected: true,backgroundImage: Image("backgroundImageForDistance"), backgroundColor: .green.opacity(0.4), textColor: .white, size: .large, title: "Enes Beyza Relationship")
//    ]
//    
//    var body: some View {
//        NavigationStack {
//            ZStack {
//                WidgetSettingsBackground()
//                VStack {
//                    // MARK: WIDGET DESIGN VIEWS
//                    if styleIndex == 0 {
//                        TabView(selection : $selectedIndex) {
//                            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
//                                DistanceWidgetPreviewDesignOne(item: item, title: $title)
//                                    .tag(index)
//                                
//                            }
//                        }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
//                            .frame(height: selectedIndex == items.count - 1 ? 450 : 250)
//                            .animation(.bouncy(duration: 0.5), value: selectedIndex)
//                            .background(Color.gray.gradient.opacity(0.1))
//                    }
//                    
//                    ScrollView {
//                        VStack {
//                           
//                            
//                            VStack {
//                                HStack {
//                                    Text("Choose Friend").bold().font(.title3)
//                                    Spacer()
//                                }
//                                
//                                ZStack {
//                                    RoundedRectangle(cornerRadius: 15)
//                                        .foregroundStyle(.gray.opacity(0.3))
//                                        .frame(height: 50)
//                                    
//                                    HStack {
//                                        Text("Henüz Seçilmedi")
//                                            .foregroundStyle(.gray)
//                                        
//                                        Spacer()
//                                        
//                                        Button {
//                                            showFriendsList = true
//                                        } label: {
//                                            Text("Choose")
//                                        }
//                                    }.padding(.horizontal)
//                                    
//                                }.sheet(isPresented: $showFriendsList) {
//                                    AddFriendListToWidget()
//                                }
//                            }.padding(.horizontal,20)
//                            
//                            VStack(alignment: .leading) {
//                                HStack {
//                                    Text("Locations").bold()
//                                    Spacer()
//                                    NavigationLink(destination: EmptyView()) {
//                                        HStack {
//                                            Text("Handle").font(.caption)
//                                            Image(systemName: "arrow.forward").foregroundStyle(.gray)
//                                        }
//                                    }
//                                }
//                                
//                                Image(systemName : "house.fill")
//                                    .resizable()
//                                    .frame(width: 20,height: 20)
//                                    .foregroundStyle(.gray)
//                                    .padding(30)
//                                    .background(.gray.opacity(0.3), in: RoundedRectangle(cornerRadius: 10))
//                            }.padding(.horizontal).padding(.top)
//                            
//                            
//                            
//                            VStack {
//                                HStack {
//                                    Text("Background").bold()
//                                    Spacer()
//                                }.padding(.horizontal).padding(.top)
//                                ScrollView(.horizontal) {
//                                    WidgetBackgroundColorPicker(backgroundColor: $backgroundColor, items: $items)
//                                }.scrollIndicators(.hidden)
//                            }
//                            
//                            VStack {
//                                HStack {
//                                    Text("Text Color").bold()
//                                    Spacer()
//                                }.padding(.horizontal).padding(.top)
//                                ScrollView(.horizontal) {
//                                    WidgetTextColorPicker(textColor: $textColor, items: $items)
//                                }
//                            }
//                            
//                            if selectedIndex != 0 {
//                                VStack {
//                                    HStack {
//                                        Text("Title").bold()
//                                        Spacer()
//                                    }.padding(.horizontal).padding(.top)
//                                    
//                                    TextField("Enter Title", text: $title)
//                                        .padding()
//                                        .background(.gray.opacity(0.3), in: RoundedRectangle(cornerRadius: 15))
//                                        .padding(.horizontal)
//                                }
//                            }
//                        }
//                    }
//                    
//                   
//                    
//                    Button {
//                        
//                    } label: {
//                        Text("Save")
//                            .bold()
//                            .frame(width: 100, height: 40)
//                            .background(.blue.opacity(0.3))
//                            .foregroundStyle(.white)
//                            .clipShape(RoundedRectangle(cornerRadius: 10))
//                    }
//                }
//            }.navigationTitle("Distance Widget")
//                .navigationBarTitleDisplayMode(.inline)
//                .toolbarBackground(.gray.opacity(0.1), for: .bottomBar)
//                .toolbar(.hidden, for: .tabBar)
//        }
//    }
// }
//
// #Preview {
//    DistanceSettingsView()
// }
//
// struct WidgetBackgroundColorPicker : View {
//    @State var colorSet : [Color] = [.black, .blue, .brown, .white, .cyan, .gray, .green, .indigo, .mint, .orange, .pink, .teal, .yellow]
//    @State private var showColorPicker: Bool = false
//    @State private var selectedColor: Color = .clear
//    @State private var selectedBackgroundPhoto: PhotosPickerItem?
//    @State private var backgroundImage: Image?
//    @Binding var backgroundColor : Color
//    @Binding var items : [DistanceWidget]
//    var body: some View {
//        HStack {
//            Button {
//                for index in items.indices {
//                    items[index].backgroundImage = Image("backgroundImageForDistance")
//                    items[index].bgSelected = true
//                }
//            } label: {
//                ZStack {
//                    RoundedRectangle(cornerRadius: 5)
//                        .frame(height: 50)
//                        .foregroundStyle(.ultraThinMaterial)
//                    
//                    HStack {
//                        Text("Default")
//                    }.foregroundStyle(.gray).padding(.horizontal)
//                }
//            }
//            
//            PhotosPicker(selection: $selectedBackgroundPhoto, matching: .images) {
//                ZStack {
//                    RoundedRectangle(cornerRadius: 5)
//                        .frame(height: 50)
//                        .foregroundStyle(.ultraThinMaterial)
//                    
//                    HStack {
//                        Image(systemName : "photo.fill")
//                        Text("Album")
//                    }.foregroundStyle(.gray).padding(.horizontal)
//                }
//            }
//            .onChange(of: selectedBackgroundPhoto) { _ in
//                Task {
//                    if let loaded = try? await selectedBackgroundPhoto?.loadTransferable(type: Image.self) {
//                        backgroundImage = loaded
//                        
//                        for index in items.indices {
//                            items[index].backgroundImage = loaded
//                            items[index].bgSelected = true
//                        }
//                    } else {
//                        print("failed")
//                    }
//                }
//            }
//            
//            Button {
//                showColorPicker = true
//            } label: {
//                RoundedRectangle(cornerRadius: 5)
//                    .frame(width: 50,height: 50)
//                    .foregroundStyle(AngularGradient(colors: [.yellow, .red, .blue], center: .center, startAngle: .zero, endAngle: .degrees(360)))
//            }
//            
//            ForEach(colorSet, id: \.self) { item in
//                RoundedRectangle(cornerRadius: 5).frame(width: 50, height: 50)
//                    .foregroundStyle(item)
//                    .onTapGesture {
//                        selectedColor = item
//                        for index in items.indices {
//                            items[index].backgroundColor = item
//                            items[index].bgSelected = false
//                        }
//                        
//                    }
//                    .overlay {
//                        if item == .white {
//                            RoundedRectangle(cornerRadius: 5)
//                                .stroke(.gray.opacity(0.2), lineWidth: 1)
//                        }
//                        if selectedColor == item { // Eğer bu renk seçildiyse stroke ekle
//                            RoundedRectangle(cornerRadius: 5)
//                                .stroke(.orange, lineWidth: 2)
//                        }
//                    }                                    }
//        }.padding(.horizontal)
//            .sheet(isPresented: $showColorPicker) {
//                ColorPickerView(title: "Color Picker", selectedColor: backgroundColor, didSelectColor: { color in
//                    for index in items.indices {
//                        items[index].backgroundColor = color
//                        items[index].bgSelected = false
//                    }
//                })
//                .padding(.top, 8)
//                .background(.white)
//                .presentationDetents([.height(640)])
//            }
//        
//    }
// }
// struct WidgetTextColorPicker : View {
//    @State var colorSet : [Color] = [.black, .blue, .brown, .white, .cyan, .gray, .green, .indigo, .mint, .orange, .pink, .teal, .yellow]
//    @State private var showColorPicker: Bool = false
//    @State private var selectedColor: Color = .clear
//    @Binding var textColor : Color
//    @Binding var items : [DistanceWidget]
//    var body: some View {
//        HStack {
//            Button {
//                showColorPicker = true
//            } label: {
//                RoundedRectangle(cornerRadius: 5)
//                    .frame(width: 50,height: 50)
//                    .foregroundStyle(AngularGradient(colors: [.yellow, .red, .blue], center: .center, startAngle: .zero, endAngle: .degrees(360)))
//            }
//            
//            ForEach(colorSet, id: \.self) { item in
//                RoundedRectangle(cornerRadius: 5).frame(width: 50, height: 50)
//                    .foregroundStyle(item)
//                    .onTapGesture {
//                        selectedColor = item
//                        for index in items.indices {
//                            items[index].textColor = item
//                        }
//                        
//                    }
//                    .overlay {
//                        if item == .white {
//                            RoundedRectangle(cornerRadius: 5)
//                                .stroke(.gray.opacity(0.2), lineWidth: 1)
//                        }
//                        if selectedColor == item { // Eğer bu renk seçildiyse stroke ekle
//                            RoundedRectangle(cornerRadius: 5)
//                                .stroke(.orange, lineWidth: 2)
//                        }
//                    }                   
//            }
//        }.padding(.horizontal)
//            .sheet(isPresented: $showColorPicker) {
//                ColorPickerView(title: "Color Picker", selectedColor: textColor, didSelectColor: { color in
//                    for index in items.indices {
//                        items[index].textColor = color
//                    }
//                })
//                .padding(.top, 8)
//                .background(.white)
//                .presentationDetents([.height(640)])
//            }
//        
//    }
// }
//
// struct AddFriendListToWidget: View {
//    var body: some View {
//        ZStack {
//            VStack(alignment: .center) {
//                HStack {
//                    Text("Choose Friend").fontWeight(.heavy).font(.title2).padding(.top,20)
//                }
//                Spacer()
//                
//                VStack {
//                    Image(systemName: "person.3.sequence")
//                        .resizable()
//                        .frame(width: 180, height: 90)
//                    Text("No Friends Yet")
//                }.opacity(0.4)
//                Spacer()
//                Button {
//                    
//                } label: {
//                    Text("Add New Friend").bold().foregroundStyle(.white)
//                        .padding(.vertical,10)
//                        .padding(.horizontal,30)
//                        .background(.blue.opacity(0.4), in: RoundedRectangle(cornerRadius: 5))
//                    
//                }
//            }.presentationDetents([.medium])
//        }
//    }
// }
//
//
//
// class ColorPickerDelegate: NSObject, UIColorPickerViewControllerDelegate {
//    var didSelectColor: ((Color) -> Void)
//    
//    init(_ didSelectColor: @escaping ((Color) -> Void)) {
//        self.didSelectColor = didSelectColor
//    }
//    
//    
//    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
//        let selectedUIColor = viewController.selectedColor
//        didSelectColor(Color(uiColor: selectedUIColor))
//    }
//    
//    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
//        print("dismiss colorPicker")
//    }
//    
// }
//
// struct ColorPickerView: UIViewControllerRepresentable {
//    private let delegate: ColorPickerDelegate
//    private let pickerTitle: String
//    private let selectedColor: UIColor
//    
//    init(title: String, selectedColor: Color, didSelectColor: @escaping ((Color) -> Void)) {
//        self.pickerTitle = title
//        self.selectedColor = UIColor(selectedColor)
//        self.delegate = ColorPickerDelegate(didSelectColor)
//    }
//    
//    func makeUIViewController(context: Context) -> UIColorPickerViewController {
//        let colorPickerController = UIColorPickerViewController()
//        colorPickerController.delegate = delegate
//        colorPickerController.title = pickerTitle
//        colorPickerController.selectedColor = selectedColor
//        return colorPickerController
//    }
//    
//    
//    func updateUIViewController(_ uiViewController: UIColorPickerViewController, context: Context) {}
// }
