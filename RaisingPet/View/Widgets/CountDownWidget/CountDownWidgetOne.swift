//
//  CarouselItem.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 11.10.2024.
//

import Foundation
import SwiftUI

struct CountDownWidgetOne: Identifiable {
    let id = UUID()
    var bgSelected: Bool
    var backgroundImage: Image?
    var backgroundColor: Color
    var textColor : Color
    var size : widgetSizeOne
    var title : String
    var targetDate : Date
}
enum widgetSizeOne {
    case small, medium, large
}

struct CountDownWidgetPreviewDesignOne: View {
    let item: CountDownWidgetOne
    @Binding var targetDate: Date
    var timeRemaining: (days: Int, hours: Int, minutes: Int)
    @Binding var title : String
    var body: some View {
        ZStack {
            if item.bgSelected {
                item.backgroundImage?.resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 25))
            } else {
                item.backgroundColor
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                
            }
            
            VStack(alignment: .leading, content: {
                HStack(alignment: .bottom) {
                    Text(title).padding(.top, 20).padding(.leading, 10).foregroundStyle(item.textColor)
                        .font(.title3)
                        .fontWeight(.heavy)
                    Spacer()
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("\(timeRemaining.days) Days").font(.title).bold().foregroundStyle(item.textColor)
                    Text("\(timeRemaining.hours) Hours").bold().foregroundStyle(item.textColor)
                    Text("\(timeRemaining.minutes) Minutes").bold().foregroundStyle(item.textColor)
                }.padding(.bottom, 10)
                    .padding(.leading)
            }).foregroundColor(.white)
        }.frame(width: item.size == .small ? 170 : 350, height: 170)
    }
}
