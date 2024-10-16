import SwiftUI
import PhotosUI


struct CountDownSettingsView: View {
    @State private var selectedBackgroundPhoto: PhotosPickerItem?
    @State private var backgroundImage: Image?
    @State private var backgroundColor: Color = .blue
    @State private var textColor: Color = .white
    @State private var bgSelected: Bool = false
    @State private var styleIndex : Int = 0
    @State private var title : String = "Title"
    
    @StateObject private var viewModel = CountDownWidgetViewModel()
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                WidgetSettingsBackground()
                ScrollView {
                    VStack(spacing: 30) {
                        // MARK: WIDGET DESIGN VIEWS
                        // TabView for showing one item at a time and swiping to see the others
                        if styleIndex == 0 {
                            TabView() {
                                ForEach(Array(viewModel.itemsOne.enumerated()), id: \.element.id) { index, item in
                                    CountDownWidgetPreviewDesignOne(item: item, targetDate: $viewModel.targetDate, timeRemaining: viewModel.timeRemaining, title: $title)
                                        .tag(index)
                                    
                                }
                            }
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic)) // Enable horizontal paging
                            .frame(height: 250)
                            .background(Color.gray.gradient.opacity(0.1))
                        } else if styleIndex == 1 {
                            TabView() {
                                ForEach(Array(viewModel.itemsTwo.enumerated()), id: \.element.id) { index, item in
                                    CountDownWidgetPreviewDesignTwo(item: item, targetDate: $viewModel.targetDate, timeRemaining: viewModel.timeRemaining, title: $title)
                                        .tag(index)
                                    
                                }
                            }
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic)) // Enable horizontal paging
                            .frame(height: 250)
                            .background(Color.gray.gradient.opacity(0.1))
                        } else if styleIndex == 2 {
                            TabView() {
                                ForEach(Array(viewModel.itemsThree.enumerated()), id: \.element.id) { index, item in
                                    CountDownWidgetPreviewDesignThree(item: item, targetDate: $viewModel.targetDate, timeRemaining: viewModel.timeRemaining, title: $title)
                                        .tag(index)
                                    
                                }
                            }
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic)) // Enable horizontal paging
                            .frame(height: 250)
                            .background(Color.gray.gradient.opacity(0.1))
                        } else if styleIndex == 3 {
                            TabView() {
                                ForEach(Array(viewModel.itemsFour.enumerated()), id: \.element.id) { index, item in
                                    CountDownWidgetPreviewDesignFour(item: item, targetDate: $viewModel.targetDate, timeRemaining: viewModel.timeRemaining, title: $title)
                                        .tag(index)
                                    
                                }
                            }
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic)) // Enable horizontal paging
                            .frame(height: 250)
                            .background(Color.gray.gradient.opacity(0.1))
                        }
                        
                        
                        // MARK: WIDGET STYLE SELECTION
                        HStack() {
                            Text("Widget Style").font(.title3).bold()
                            Spacer()
                        }.padding(.horizontal)
                        
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(0..<4) { item in
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10).foregroundStyle(backgroundColor)
                                        Text("Style \(item + 1)").foregroundStyle(textColor)
                                    }.frame(width: 80, height: 40)
                                        .onTapGesture {
                                            styleIndex = item
                                        }
                                }
                            }
                        }.padding(.horizontal)
                            .scrollIndicators(.hidden)
                       
                        
                        // MARK: BACKGROUND PHOTO & BACKGROUND COLOR & TEXT COLOR SELECTION
                        VStack {
                            
                            if styleIndex != 2 {
                                PhotosPicker(selection: $selectedBackgroundPhoto, matching: .images) {
                                    HStack {
                                        Text("Select a background photo")
                                        Spacer()
                                        Image(systemName: "photo.on.rectangle.angled")
                                    }.padding(.horizontal)
                                }
                                .onChange(of: selectedBackgroundPhoto) {
                                    Task {
                                        if let loaded = try? await selectedBackgroundPhoto?.loadTransferable(type: Image.self) {
                                            backgroundImage = loaded
                                            // Set the selected background image for all items
                                            for index in viewModel.itemsOne.indices {
                                                viewModel.itemsOne[index].backgroundImage = loaded
                                                viewModel.itemsOne[index].bgSelected = true
                                                viewModel.itemsTwo[index].backgroundImage = loaded
                                                viewModel.itemsTwo[index].bgSelected = true
                                                viewModel.itemsFour[index].backgroundImage = loaded
                                                viewModel.itemsFour[index].bgSelected = true
                                            }
                                        } else {
                                            print("failed")
                                        }
                                    }
                                }
                            }
                            
                            
                            
                            ColorPicker("Select background color", selection: $backgroundColor)
                                .padding(.horizontal)
                                .onChange(of: backgroundColor) {
                                    for index in viewModel.itemsOne.indices {
                                        viewModel.itemsOne[index].backgroundColor = backgroundColor
                                        viewModel.itemsOne[index].bgSelected = false // Deselect photo when color is picked
                                        viewModel.itemsTwo[index].backgroundColor = backgroundColor
                                        viewModel.itemsTwo[index].bgSelected = false // Deselect photo when color is picked
                                        viewModel.itemsThree[index].backgroundColor = backgroundColor
                                        viewModel.itemsFour[index].backgroundColor = backgroundColor
                                        viewModel.itemsFour[index].bgSelected = false // Deselect photo when color is picked
                                        
                                    }
                                }
                            ColorPicker("Select text color", selection: $textColor)
                                .padding(.horizontal)
                                .onChange(of: textColor) {
                                    for index in viewModel.itemsOne.indices {
                                        viewModel.itemsOne[index].textColor = textColor
                                        viewModel.itemsTwo[index].textColor = textColor
                                        viewModel.itemsThree[index].textColor = textColor
                                        viewModel.itemsFour[index].textColor = textColor
                                    }
                                }
                        }
                        
                        // MARK: TITLE TEXTFIELD
                        TextField("Enter Title", text: $title).padding(.horizontal)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                        // MARK: DATE PICKER
                        DatePicker("Target Date", selection: viewModel.$targetDate, displayedComponents: [.date, .hourAndMinute])
                            .onChange(of: viewModel.targetDate) {
                                viewModel.updateRemainingTime()
                            }.padding(.horizontal)
                        
                        
                        // MARK: SAVE BUTTON
                        Button {
                            
                        } label: {
                            Text("Save")
                                .bold()
                                .frame(width: 100,height: 40)
                                .background(backgroundColor)
                                .foregroundStyle(textColor)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        
                        Spacer()
                        
                    }
                }
            }
            .navigationTitle("Countdown Widget")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
        }
    }
}

#Preview {
    CountDownSettingsView()
}

struct WidgetSettingsBackground: View {
    var body: some View {
        Color("WidgetSettingsBackgroundColor").ignoresSafeArea()
    }
}


