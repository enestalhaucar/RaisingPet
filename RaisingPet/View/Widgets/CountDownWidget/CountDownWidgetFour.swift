//
//  CountDownWidgetFour.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 15.10.2024.
//

import SwiftUI

struct CountdownWidgetPreviewDesignFour: View {
    let item: PetiverseWidgetItem
    let timeRemaining: (days: Int, hours: Int, minutes: Int)
    let backgroundColor: Color
    let textColor: Color
    
    private func totalDays() -> Int {
        guard let targetDate = item.targetDate else { return 1 }
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let startOfTarget = calendar.startOfDay(for: targetDate)
        let components = calendar.dateComponents([.day], from: startOfDay, to: startOfTarget)
        return max(components.day ?? 0, 1)
    }
    
    var body: some View {
        ZStack {
            if let base64String = item.backgroundImageData,
               let data = Data(base64Encoded: base64String),
               let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(
                        width: item.size == .small ? 170 : item.size == .medium ? 350 : 500,
                        height: item.size == .small ? 170 : item.size == .medium ? 170 : 250
                    )
                    .aspectRatio(contentMode: .fill)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
            } else {
                backgroundColor
                    .frame(
                        width: item.size == .small ? 170 : item.size == .medium ? 350 : 350,
                        height: item.size == .small ? 170 : item.size == .medium ? 170 : 350
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 25))
            }
            
            VStack(alignment: item.size == .small ? .center : .trailing) {
                HStack {
                    Text(item.title)
                        .padding(.top, 15)
                        .padding(.leading, 10)
                        .foregroundStyle(textColor)
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
                        .trim(from: 0, to: CGFloat(timeRemaining.days) / CGFloat(totalDays()))
                        .stroke(textColor, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                        .rotationEffect(.degrees(-90))
                        .frame(width: 80, height: 80)
                    Text("\(timeRemaining.days) Days")
                        .foregroundStyle(textColor)
                }
                .offset(y: item.size == .medium ? -10 : 0)
            }
            .padding(.bottom, 20)
        }
        .frame(
            width: item.size == .small ? 170 : item.size == .medium ? 350 : 500,
            height: item.size == .small ? 170 : item.size == .medium ? 170 : 250
        )
    }
}
