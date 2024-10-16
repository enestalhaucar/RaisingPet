//
//  CountDownWidgetFour.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 15.10.2024.
//

import SwiftUI

struct CountDownWidgetFour: Identifiable {
    let id = UUID()
    var bgSelected: Bool
    var backgroundImage: Image?
    var backgroundColor: Color
    var textColor : Color
    var size : widgetSizeOne
    var title : String
    var targetDate : Date
    
}

struct CountDownWidgetPreviewDesignFour: View {
    let item: CountDownWidgetFour
    @Binding var targetDate: Date
    var timeRemaining: (days: Int, hours: Int, minutes: Int)
    
    @Binding var title : String
    
    private func totalDays() -> Int {
           let calendar = Calendar.current
           let startOfDay = calendar.startOfDay(for: Date())
           let startOfTarget = calendar.startOfDay(for: targetDate)
           let components = calendar.dateComponents([.day], from: startOfDay, to: startOfTarget)
           return max(components.day ?? 0, 1)  // En az 1 gün
       }
    var body: some View {
        ZStack {
            
            if item.bgSelected {
                item.backgroundImage?.resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 25))
            } else {
                item.backgroundColor
                    .clipShape(RoundedRectangle(cornerRadius: 25))
            }
            
            VStack(alignment: item.size == .small ? .center : .trailing) {
                HStack() {
                    Text(title).padding(.top, 15).padding(.leading, 10).foregroundStyle(item.textColor)
                        .font(.system(size: 20))
                        .fontWeight(.light)
                        
                    Spacer()
                }
                Spacer()
                ZStack {
                    Circle()
                        .stroke(.white, lineWidth: 10)
                        .opacity(0.3)
                        .frame(width: 80, height: 80)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(timeRemaining.days ) / CGFloat(totalDays()))
                        .stroke(item.textColor ,style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                        .rotationEffect(.degrees(-90))
                        .frame(width: 80, height: 80)
                    
                    Text("\(timeRemaining.days) Days").foregroundStyle(item.textColor)
                }.offset(y: item.size == .medium ? -10 : 0)
            }.padding(.bottom,20)
                
            
        }.frame(width: item.size == .small ? 170 : 350, height: 170)
    }
    
    
   
    
}

#Preview {
    CountDownSettingsView()
}
