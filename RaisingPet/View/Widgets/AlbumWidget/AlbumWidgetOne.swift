////
////  AlbumWidgetOne.swift
////  RaisingPet
////
////  Created by Enes Talha Uçar  on 21.10.2024.
////
//
//import SwiftUI
//
//struct AlbumWidget : Identifiable, Equatable {
//    var id = UUID()
//    var backgroundImage : [Image?]
////    var size : widgetSizeOne
//    var frameColor : Color?
//    var lineWidth : CGFloat = 5
//    
//}
//
//struct AlbumWidgetPreviewDesign: View {
//    let item : AlbumWidget
//    var body: some View {
//        ZStack {
//            
//            if item.backgroundImage == [] {
//                if item.frameColor == nil {
//                    Color.blue.opacity(0.3)
//                        .clipShape(RoundedRectangle(cornerRadius: 25))
//                } else {
//                    Color.blue.opacity(0.3)
//                        .clipShape(RoundedRectangle(cornerRadius: 25))
//                        .overlay  {
//                            RoundedRectangle(cornerRadius: 25)
//                                .stroke(item.frameColor! ,lineWidth: item.lineWidth)
//                        }
//
//                }
//            } else {
//                if item.frameColor == nil {
//                    item.backgroundImage[0]?
//                        .resizable()
//                        .clipShape(RoundedRectangle(cornerRadius: 25))
//                } else {
//                    item.backgroundImage[0]?
//                        .resizable()
//                        .clipShape(RoundedRectangle(cornerRadius: 25))
//                        .overlay  {
//                            RoundedRectangle(cornerRadius: 25)
//                                .stroke(item.frameColor! ,lineWidth: item.lineWidth)
//                        }
//                }
//                
//                    
//            }
//
//            
//            
//        }.frame(width: item.size == .small ? 170 : 350, height: item.size == .large ? 350 : 170)
//    }
//}
//
//#Preview {
//    AlbumSettingsView()
//}
