////
////  DistanceWidgetOne.swift
////  RaisingPet
////
////  Created by Enes Talha Uçar  on 16.10.2024.
////
//
//import SwiftUI
//
//struct DistanceWidget : Identifiable, Equatable {
//    var id = UUID()
//    var bgSelected : Bool
//    var backgroundImage : Image?
//    var backgroundColor : Color
//    var textColor : Color
//    var size : widgetSizeOne
//    var title : String
//}
//
//struct DistanceWidgetPreviewDesignOne: View {
//    let item : DistanceWidget
//    @Binding var title : String
//    var body: some View {
//        ZStack {
//            if item.bgSelected {
//                item.backgroundImage?
//                    .resizable()
//                    .clipShape(RoundedRectangle(cornerRadius: 25))
//            } else {
//                item.backgroundColor
//                    .clipShape(RoundedRectangle(cornerRadius: 25))
//            }
//            
//            VStack() {
//                if item.size == .small {
//                    GeometryReader { geo in
//                        let start = CGPoint(x: geo.size.width * 0.2, y: geo.size.height * 0.8)
//                        let end = CGPoint(x: geo.size.width * 0.8, y: geo.size.height * 0.2)
//                        
//                        // Noktalı Çizgi
//                        Path { path in
//                            path.move(to: start)
//                            path.addLine(to: end)
//                        }
//                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
//                        .foregroundColor(item.textColor)
//                        
//                        // 2.1. Sol Alt Profil - Friends Photo
//                        Circle()
//                            .fill(Color.white)
//                            .frame(width: 50, height: 50)
//                            .overlay {
//                                Circle()
//                                    .stroke(item.textColor, lineWidth: 4)
//                            }
//                            .overlay(
//                                Image("profile1") // Sol alttaki profil resmi
//                                    .resizable()
//                                    .clipShape(Circle())
//                                
//                            )
//                            .position(start)
//                        
//                        
//                        // 2.2. Sağ Üst Profil - user profile photo
//                        Circle()
//                            .fill(Color.white)
//                            .frame(width: 40, height: 40)
//                            .overlay {
//                                Circle()
//                                    .stroke(item.textColor, lineWidth: 4)
//                            }
//                            .overlay(
//                                Image("profile2") // Sağ üstteki profil resmi
//                                    .resizable()
//                                    .clipShape(Circle())
//                            )
//                            .position(end)
//                        
//                        // 3. Mesafe Metni
//                        Text("2 km")
//                            .foregroundColor(item.textColor)
//                            .bold()
//                            .position(x: geo.size.width / 1.3, y: geo.size.height / 1.7)
//                    }
//                    .padding()
//                }
//                if item.size == .medium {
//                    GeometryReader { geo in
//                        let start = CGPoint(x: geo.size.width * 0.2, y: geo.size.height * 0.5)
//                        let end = CGPoint(x: geo.size.width * 0.8, y: geo.size.height * 0.5)
//                        
//                        // Noktalı Çizgi
//                        Path { path in
//                            path.move(to: start)
//                            path.addLine(to: end)
//                        }
//                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
//                        .foregroundColor(item.textColor)
//                        
//                        Circle()
//                            .fill(Color.white)
//                            .frame(width: 60, height: 60)
//                            .overlay {
//                                Circle()
//                                    .stroke(item.textColor, lineWidth: 4)
//                            }
//                            .overlay(
//                                Image("profile1") // Sol alttaki profil resmi
//                                    .resizable()
//                                    .clipShape(Circle())
//                                
//                            )
//                            .position(start)
//                        
//                        Circle()
//                            .fill(Color.white)
//                            .frame(width: 60, height: 60)
//                            .overlay {
//                                Circle()
//                                    .stroke(item.textColor, lineWidth: 4)
//                            }
//                            .overlay(
//                                Image("profile2") // Sağ üstteki profil resmi
//                                    .resizable()
//                                    .clipShape(Circle())
//                            )
//                            .position(end)
//                        
//                        
//                        Text("2 km")
//                            .foregroundStyle(item.textColor)
//                            .bold()
//                            .position(x: geo.size.width / 2, y: geo.size.height / 2.40)
//                        
//                        Text(title)
//                            .foregroundStyle(item.textColor)
//                            .font(.title3) 
//                            .fontWeight(.heavy)
//                            .position(x: geo.size.width / 2, y: geo.size.height / 10)
//                        
//                        Text("Last Updated 2 hours")
//                            .foregroundStyle(item.textColor)
//                            .bold()
//                            .font(.system(size: 15))
//                            .position(x: geo.size.width / 2, y: geo.size.height / 1.1)
//                    }
//                }
//                if item.size == .large {
//                    GeometryReader { geo in
//                        let start = CGPoint(x: geo.size.width * 0.2, y: geo.size.height * 0.8)
//                        let end = CGPoint(x: geo.size.width * 0.8, y: geo.size.height * 0.8)
//                        
//                        Path { path in
//                            path.move(to: start)
//                            path.addLine(to: end)
//                        }.stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
//                            .foregroundStyle(item.textColor)
//                        
//                        Circle()
//                            .fill(Color.white)
//                            .frame(width: 60, height: 60)
//                            .overlay {
//                                Circle()
//                                    .stroke(item.textColor, lineWidth: 4)
//                            }
//                            .overlay(
//                                Image("profile1") // Sol alttaki profil resmi
//                                    .resizable()
//                                    .clipShape(Circle())
//                                
//                            )
//                            .position(start)
//                        
//                        Circle()
//                            .fill(Color.white)
//                            .frame(width: 60, height: 60)
//                            .overlay {
//                                Circle()
//                                    .stroke(item.textColor, lineWidth: 4)
//                            }
//                            .overlay(
//                                Image("profile2") // Sağ üstteki profil resmi
//                                    .resizable()
//                                    .clipShape(Circle())
//                            )
//                            .position(end)
//                        
//                        
//                        Text("2 km")
//                            .foregroundStyle(item.textColor)
//                            .bold()
//                            .position(x: geo.size.width / 2, y: geo.size.height / 1.35)
//                        
//                        Text(title)
//                            .foregroundStyle(item.textColor)
//                            .font(.title3)
//                            .fontWeight(.heavy)
//                            .position(x: geo.size.width / 2, y: geo.size.height / 10)
//                        
//                        Text("Last Updated 2 hours")
//                            .foregroundStyle(item.textColor)
//                            .bold()
//                            .font(.system(size: 15))
//                            .position(x: geo.size.width / 2, y: geo.size.height / 1.05)
//                        
//                    }
//                }
//                
//            }
//            
//            
//        }.frame(width: item.size == .small ? 170 : 350, height: item.size == .large ? 350 : 170)
//        
//    }
//}
//
//#Preview {
//    DistanceSettingsView()
//}
