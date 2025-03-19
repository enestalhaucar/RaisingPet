



import SwiftUI
import PhotosUI

struct CountDownSettingsView: View {
    @StateObject private var viewModel = CountDownSettingsViewModel()
    @State private var selectedBackgroundPhoto: PhotosPickerItem?
    @State private var backgroundImage: Image?
    @State private var backgroundColor: Color = .blue
    @State private var textColor: Color = .white
    @State private var styleIndex: Int = 0
    @State private var sizeIndex: Int = 0
    @State private var title: String = "Title"
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGray6).ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 15) {
                        TabView(selection: $sizeIndex) {
                            previewWidget(size: .small).tag(0)
                            previewWidget(size: .medium).tag(1)
                            previewWidget(size: .large).tag(2)
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                        .frame(height: 300)
                        .background(Color.white.opacity(0.1))
                        .animation(.easeInOut(duration: 0.3), value: sizeIndex)
                        
                        HStack {
                            Text("Widget Style").font(.title3).bold()
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(0..<4) { item in
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundStyle(styleIndex == item ? backgroundColor : .gray)
                                        Text("\(item + 1)")
                                            .foregroundStyle(textColor)
                                    }
                                    .frame(width: 60, height: 60)
                                    .onTapGesture { styleIndex = item }
                                }
                            }
                        }
                        .padding(.horizontal)
                        .scrollIndicators(.hidden)
                        
                        TextFieldView(title: $title)
                        
                        DatePicker("Target Date", selection: $viewModel.targetDate, displayedComponents: [.date, .hourAndMinute])
                            .padding(.horizontal)
                        
                        WidgetBackgroundPhotoPickerView(
                            styleIndex: $styleIndex,
                            selectedBackgroundPhoto: $selectedBackgroundPhoto,
                            backgroundImage: $backgroundImage
                        )
                        
                        WidgetBackgroundColorPickerView(
                            backgroundColor: $backgroundColor
                        )
                        
                        WidgetTextColorPickerView(
                            textColor: $textColor
                        )
                        
                        Button(action: saveWidget) {
                            Text("Save")
                                .bold()
                                .frame(width: 100, height: 40)
                                .background(backgroundColor)
                                .foregroundStyle(textColor)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }
            }
            .navigationTitle("Countdown Widget")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
        }
    }
    
    @ViewBuilder
    func previewWidget(size: WidgetSize) -> some View {
        let widget = PetiverseWidgetItem(
            type: .countdown,
            title: title,
            backgroundColor: backgroundColor.description,
            textColor: textColor.description,
            backgroundImageData: backgroundImage != nil ? uiImage(from: backgroundImage!)?.jpegData(compressionQuality: 1.0) : nil,
            size: size,
            countdownStyle: CountdownStyle(rawValue: styleIndex),
            targetDate: viewModel.targetDate
        )
        
        Group {
            switch styleIndex {
            case 0:
                CountdownWidgetPreviewDesignOne(
                    item: widget,
                    timeRemaining: viewModel.timeRemaining,
                    backgroundColor: backgroundColor,
                    textColor: textColor
                )
            case 1:
                CountdownWidgetPreviewDesignTwo(
                    item: widget,
                    timeRemaining: viewModel.timeRemaining,
                    backgroundColor: backgroundColor,
                    textColor: textColor
                )
            case 2:
                CountdownWidgetPreviewDesignThree(
                    item: widget,
                    timeRemaining: viewModel.timeRemaining,
                    backgroundColor: backgroundColor,
                    textColor: textColor
                )
            case 3:
                CountdownWidgetPreviewDesignFour(
                    item: widget,
                    timeRemaining: viewModel.timeRemaining,
                    backgroundColor: backgroundColor,
                    textColor: textColor
                )
            default:
                Text("No style selected")
                    .frame(width: 170, height: 170)
                    .background(backgroundColor)
                    .foregroundStyle(textColor)
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.black.opacity(0.3), lineWidth: 2)
        )
    }
    
    func saveWidget() {
        let imageData: Data? = backgroundImage != nil ? uiImage(from: backgroundImage!)?.jpegData(compressionQuality: 1.0) : nil
        
        let size: WidgetSize = {
            switch sizeIndex {
            case 0: return .small
            case 1: return .medium
            case 2: return .large
            default: return .small
            }
        }()
        
        let widget = PetiverseWidgetItem(
            type: .countdown,
            title: title,
            backgroundColor: backgroundColor.description,
            textColor: textColor.description,
            backgroundImageData: imageData,
            size: size,
            countdownStyle: CountdownStyle(rawValue: styleIndex),
            targetDate: viewModel.targetDate
        )
        
        saveToUserDefaults(widget: widget)
        
        title = "Title"
        selectedBackgroundPhoto = nil
        backgroundImage = nil
    }
    
    func saveToUserDefaults(widget: PetiverseWidgetItem) {
        let suiteName = "group.com.petiverse.widgets"
        guard let userDefaults = UserDefaults(suiteName: suiteName) else {
            print("UserDefaults nil döndü, App Group doğru ayarlanmamış!")
            return
        }
        
        var savedWidgets: [PetiverseWidgetItem] = []
        if let data = userDefaults.data(forKey: "savedWidgets"),
           let decoded = try? JSONDecoder().decode([PetiverseWidgetItem].self, from: data) {
            savedWidgets = decoded
        }
        
        savedWidgets.append(widget)
        if let encoded = try? JSONEncoder().encode(savedWidgets) {
            userDefaults.set(encoded, forKey: "savedWidgets")
            print("Widget kaydedildi: \(widget.title) - Size: \(widget.size.rawValue)")
        } else {
            print("Widget encode edilemedi")
        }
    }
    
    func uiImage(from image: Image) -> UIImage? {
        let controller = UIHostingController(rootView: image)
        let view = controller.view
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 170, height: 170))
        return renderer.image { _ in
            view?.drawHierarchy(in: renderer.format.bounds, afterScreenUpdates: true)
        }
    }
}


struct WidgetSettingsBackground: View {
    var body: some View {
        Color("WidgetSettingsBackgroundColor").ignoresSafeArea()
    }
}

struct TextFieldView: View {
    @Binding var title: String
    var body: some View {
        TextField("Enter Title", text: $title)
            .padding(.horizontal)
            .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}

