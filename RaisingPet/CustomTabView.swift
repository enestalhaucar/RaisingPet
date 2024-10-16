////
////  CustomTabView.swift
////  RaisingPet
////
////  Created by Enes Talha Uçar  on 12.10.2024.
////
//
//import SwiftUI
//
//struct CustomTabView: View {
//    @Binding var selectedTab : String
//    var body: some View {
//        HStack {
//            TabView(image: "ButtonBarHouseIcon", selectedTab: $selectedTab)
//            TabView(image: "ButtonBarCoupleQuestionIcon", selectedTab: $selectedTab)
//            TabView(image: "ButtonBarEmotionsIcon", selectedTab: $selectedTab)
//            TabView(image: "ButtonBarPersonIcon", selectedTab: $selectedTab)
//        }.ignoresSafeArea()
//        .background(Color("buttonBarBackgroundColor"))
//            .clipShape(RoundedRectangle(cornerRadius: 20))
//            
//            
//            
//        
//    }
//}
//
//#Preview {
//    RootView2()
//}
//
//struct TabView : View {
//    let image : String
//    @Binding var selectedTab : String
//    
//    var body: some View {
//        GeometryReader { button in
//            Button {
//                withAnimation(.linear(duration: 0.3)) {
//                    selectedTab = image
//                }
//            } label: {
//                VStack {
//                    Image("\(image)")
//                        .resizable()
//                        .frame(width: 30, height: 30)
//                        .foregroundStyle(.black)
//                }
//            }.frame(maxWidth: .infinity, maxHeight: .infinity)
//            
//        }.frame(height: 80)
//    }
//}
