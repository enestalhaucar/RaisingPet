////
////  MyWidgetsView.swift
////  RaisingPet
////
////  Created by Enes Talha Uçar  on 12.12.2024.
////
//
// import SwiftUI
//
// struct MyWidgetsView: View {
//    
//    @State private var CountDownItem: CountDownWidgetOne =
//    CountDownWidgetOne(bgSelected: false, backgroundImage: nil, backgroundColor: .blue, textColor: .white, size: .small, title: "Maldives", targetDate: Date())
//    
//    @State private var CountDownItem2: CountDownWidgetOne =
//    CountDownWidgetOne(bgSelected: false, backgroundImage: nil, backgroundColor: .blue, textColor: .white, size: .medium, title: "Maldives", targetDate: Date())
//    
//    
//    @State private var DistanceItem : DistanceWidget = DistanceWidget(bgSelected: true, backgroundImage: Image("backgroundImageForDistance"), backgroundColor: .green.opacity(0.3), textColor: .white, size: .small, title: "")
//    @State private var DistanceItem2 : DistanceWidget = DistanceWidget(bgSelected: true, backgroundImage: Image("backgroundImageForDistance"), backgroundColor: .green.opacity(0.3), textColor: .white, size: .medium, title: "")
//    
//    @State private var AlbumItem : AlbumWidget = AlbumWidget(backgroundImage: [Image("profile1")], size: widgetSizeOne.small)
//    @State private var AlbumItem2 : AlbumWidget = AlbumWidget(backgroundImage: [Image("profile2")], size: widgetSizeOne.large)
//    
//    @State var title = "To Maldives"
//    
//    @State private var selectedSize : WidgetSize = .medium
//    @State private var targetDate: Date = Date().addingTimeInterval(60 * 60 * 24 * 23) // Default 23 days later
//    @State private var timeRemaining: (days: Int, hours: Int, minutes: Int) = (0, 0, 0)
//    
//    var body: some View {
//        NavigationStack {
//            ZStack {
//                VStack {
//                    myWidgetsTopSide(selectedSize: $selectedSize)
//                    Divider()
//                    ScrollView {
//                        LazyVStack {
//                            if selectedSize == .small {
//                                HStack {
//                                    CountDownWidgetPreviewDesignOne(item: CountDownItem, targetDate: $targetDate, timeRemaining: timeRemaining, title: $title)
//                                    
//                                    DistanceWidgetPreviewDesignOne(item: DistanceItem, title: $title)
//                                }
//                            }
//                            if selectedSize == .medium {
//                                VStack {
//                                    DistanceWidgetPreviewDesignOne(item: DistanceItem2, title: $title)
//                                    CountDownWidgetPreviewDesignOne(item: CountDownItem2, targetDate: $targetDate, timeRemaining: timeRemaining, title: $title)
//                                }
//                            }
//                            if selectedSize == .large {
//                                AlbumWidgetPreviewDesign(item: AlbumItem2)
//                            }
//                        }
//                    }
//                    
//                    Spacer()
//                }
//            }
//            .navigationTitle("my_widgets".localized())
//            .navigationBarTitleDisplayMode(.inline)
//        }
//    }
// }
//
// #Preview {
//    MyWidgetsView()
// }
//
// struct myWidgetsTopSide : View {
//    @Binding var selectedSize : WidgetSize
//    var body: some View {
//        ZStack {
//            VStack {
//                LockScreenOrHomeWidgets()
//                Picker("Widget Size", selection: $selectedSize) {
//                    ForEach(WidgetSize.allCases, id: \.self) { item in
//                        Text(item.rawValue)
//                            .tag(item)
//                    }
//                }.pickerStyle(SegmentedPickerStyle())
//                    .padding()
//            }
//            
//        }
//        .frame(width: UIScreen.main.bounds.size.width)
//    }
// }
//
// struct LockScreenOrHomeWidgets: View {
//    var body: some View {
//        HStack {
//            Button {
//                
//            } label: {
//                widgetsSelectionButtonView(imageName: "lock.fill", text: "Lock Screen")
//            }
//            Button {
//                
//            } label: {
//                widgetsSelectionButtonView(imageName: "house.fill", text: "Home Screen")
//            }
//        }.padding(10)
//    }
// }
//
// struct widgetsSelectionButtonView : View {
//    var imageName : String
//    var text : String
//    var body: some View {
//        HStack(spacing: 15) {
//            HStack(spacing: 5) {
//                Image(systemName: imageName)
//                Text(text)
//            }.padding(10)
//                .frame(width: 180)
//                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black,lineWidth: 1))
//        }
//    }
// }
//
//
