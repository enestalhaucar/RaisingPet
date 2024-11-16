//
//  CountDownWidgetTwo.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 11.10.2024.
//

import Foundation
import SwiftUI

struct CountDownWidgetTwo: Identifiable {
    let id = UUID()
    var bgSelected: Bool
    var backgroundImage: Image?
    var backgroundColor: Color
    var textColor : Color
    var size : widgetSizeOne
    var title : String
    var targetDate : Date
}

enum widgetSizeTwo {
    case small, medium
}

struct CountDownWidgetPreviewDesignTwo: View {
    let item: CountDownWidgetTwo
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
                
                
                HStack(alignment: .bottom) {
                    Text("\(timeRemaining.days)").font(.system(size: 60)).bold().foregroundStyle(item.textColor).padding(.leading).offset(y: 10)
                    
                    
                    Text("Days").font(.title).foregroundStyle(item.textColor).fontWeight(.light)
                    
                    Spacer()
                }.padding(.bottom, 10)
                
                
            }).foregroundColor(.white)
        }.frame(width: item.size == .small ? 170 : 350, height: 170)
    }
}

#Preview {
    CountDownSettingsView()
}



