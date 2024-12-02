import SwiftUI
import PhotosUI

struct CountDownSettingsView: View {
    @StateObject private var viewModel = CountDownSettingsViewModel()
    @State private var selectedBackgroundPhoto: PhotosPickerItem?
    @State private var backgroundImage: Image?
    @State private var backgroundColor: Color = .blue
    @State private var textColor: Color = .white
    @State private var bgSelected: Bool = false
    @State private var styleIndex: Int = 0
    @State private var title: String = "Title"

    var body: some View {
        NavigationStack {
            ZStack {
                WidgetSettingsBackground()
                ScrollView {
                    VStack(spacing: 15) {
                        // WIDGET DESIGN VIEWS
                        WidgetDesignViews(
                            viewModel: viewModel,
                            styleIndex: $styleIndex,
                            title: $title
                        )
                        
                        // WIDGET STYLE SELECTION
                        HStack {
                            Text("Widget Style").font(.title3).bold()
                            Spacer()
                        }.padding(.horizontal)
                        
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(0..<4) { item in
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10).foregroundStyle(backgroundColor)
                                        Text("\(item + 1)").foregroundStyle(textColor)
                                    }
                                    .frame(width: 60, height: 60)
                                    .onTapGesture { styleIndex = item }
                                }
                            }
                        }
                        .padding(.horizontal)
                        .scrollIndicators(.hidden)
                        
                        // TITLE TEXTFIELD
                        TextFieldView(title: $title)
                        
                        // DATE PICKER
                        DatePicker("Target Date", selection: $viewModel.targetDate, displayedComponents: [.date, .hourAndMinute])
                            .padding(.horizontal)
                        
                        // SAVE BUTTON
                        Button {
                            // Save logic
                        } label: {
                            Text("Save")
                                .bold()
                                .frame(width: 100, height: 40)
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


#Preview {
    CountDownSettingsView()
}
