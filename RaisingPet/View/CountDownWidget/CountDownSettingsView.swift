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
    
    
    
    @State var timeRemaining: (days: Int, hours: Int, minutes: Int) = (0, 0, 0)
    @State var targetDate: Date = Date().addingTimeInterval(60 * 60 * 24 * 23) // Default 23 days later
    
    @State var itemsOne: [CountDownWidgetOne] = [
        CountDownWidgetOne(bgSelected: false, backgroundImage: nil, backgroundColor: .blue, textColor: .white, size: .small, title: "Maldives", targetDate: Date()),
        CountDownWidgetOne(bgSelected: false, backgroundImage: nil, backgroundColor: .blue, textColor: .white, size: .medium, title: "Maldives", targetDate: Date())
    ]
    @State var itemsTwo: [CountDownWidgetTwo] = [
        CountDownWidgetTwo(bgSelected: false, backgroundImage: nil, backgroundColor: .blue, textColor: .white, size: .small, title: "Maldives", targetDate: Date()),
        CountDownWidgetTwo(bgSelected: false, backgroundImage: nil, backgroundColor: .blue, textColor: .white, size: .medium, title: "Maldives", targetDate: Date())
    ]
    @State var itemsThree: [CountDownWidgetThree] = [
        CountDownWidgetThree(backgroundColor: .blue, textColor: .white, size: .small, title: "Maldives", targetDate: Date()),
        CountDownWidgetThree(backgroundColor: .blue, textColor: .white, size: .medium, title: "Maldives", targetDate: Date())
    ]
    @State var itemsFour: [CountDownWidgetFour] = [
        CountDownWidgetFour(bgSelected: false, backgroundImage: nil, backgroundColor: .blue, textColor: .white, size: .small, title: "Maldives", targetDate: Date()),
        CountDownWidgetFour(bgSelected: false, backgroundImage: nil, backgroundColor: .blue, textColor: .white, size: .medium, title: "Maldives", targetDate: Date())
    ]
    
    func updateRemainingTime() {
        let now = Date()
        let diff = Calendar.current.dateComponents([.day, .hour, .minute], from: now, to: targetDate)
        timeRemaining.days = diff.day ?? 0
        timeRemaining.hours = diff.hour ?? 0
        timeRemaining.minutes = diff.minute ?? 0
    }
    @State private var timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect() // Timer to update every minute
    
    
    
    
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
                                ForEach(Array(itemsOne.enumerated()), id: \.element.id) { index, item in
                                    CountDownWidgetPreviewDesignOne(item: item, targetDate: $targetDate, timeRemaining: timeRemaining, title: $title)
                                        .tag(index)
                                    
                                }
                            }
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic)) // Enable horizontal paging
                            .frame(height: 250)
                            .background(Color.gray.gradient.opacity(0.1))
                        } else if styleIndex == 1 {
                            TabView() {
                                ForEach(Array(itemsTwo.enumerated()), id: \.element.id) { index, item in
                                    CountDownWidgetPreviewDesignTwo(item: item, targetDate: $targetDate, timeRemaining: timeRemaining, title: $title)
                                        .tag(index)
                                    
                                }
                            }
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic)) // Enable horizontal paging
                            .frame(height: 250)
                            .background(Color.gray.gradient.opacity(0.1))
                        } else if styleIndex == 2 {
                            TabView() {
                                ForEach(Array(itemsThree.enumerated()), id: \.element.id) { index, item in
                                    CountDownWidgetPreviewDesignThree(item: item, targetDate: $targetDate, timeRemaining: timeRemaining, title: $title)
                                        .tag(index)
                                    
                                }
                            }
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic)) // Enable horizontal paging
                            .frame(height: 250)
                            .background(Color.gray.gradient.opacity(0.1))
                        } else if styleIndex == 3 {
                            TabView() {
                                ForEach(Array(itemsFour.enumerated()), id: \.element.id) { index, item in
                                    CountDownWidgetPreviewDesignFour(item: item, targetDate: $targetDate, timeRemaining: timeRemaining, title: $title)
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
                                            for index in itemsOne.indices {
                                                itemsOne[index].backgroundImage = loaded
                                                itemsOne[index].bgSelected = true
                                                itemsTwo[index].backgroundImage = loaded
                                                itemsTwo[index].bgSelected = true
                                                itemsFour[index].backgroundImage = loaded
                                                itemsFour[index].bgSelected = true
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
                                    for index in itemsOne.indices {
                                        itemsOne[index].backgroundColor = backgroundColor
                                        itemsOne[index].bgSelected = false // Deselect photo when color is picked
                                        itemsTwo[index].backgroundColor = backgroundColor
                                        itemsTwo[index].bgSelected = false // Deselect photo when color is picked
                                        itemsThree[index].backgroundColor = backgroundColor
                                        itemsFour[index].backgroundColor = backgroundColor
                                        itemsFour[index].bgSelected = false // Deselect photo when color is picked
                                        
                                    }
                                }
                            ColorPicker("Select text color", selection: $textColor)
                                .padding(.horizontal)
                                .onChange(of: textColor) {
                                    for index in itemsOne.indices {
                                        itemsOne[index].textColor = textColor
                                        itemsTwo[index].textColor = textColor
                                        itemsThree[index].textColor = textColor
                                        itemsFour[index].textColor = textColor
                                    }
                                }
                        }
                        
                        // MARK: TITLE TEXTFIELD
                        TextField("Enter Title", text: $title).padding(.horizontal)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        // MARK: DATE PICKER
                        DatePicker("Target Date", selection: $targetDate, displayedComponents: [.date, .hourAndMinute])
                            .onChange(of: targetDate) {
                                updateRemainingTime()
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


