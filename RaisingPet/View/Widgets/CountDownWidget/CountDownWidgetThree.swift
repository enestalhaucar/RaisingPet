//
//  CountDownWidgetThree.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 15.10.2024.
//

import SwiftUI

struct CountdownWidgetPreviewDesignThree: View {
    let item: PetiverseWidgetItem
    let timeRemaining: (days: Int, hours: Int, minutes: Int)
    let backgroundColor: Color
    let textColor: Color
    var body: some View {
        ZStack {
            Color(backgroundColor)
                .frame(
                    width: item.size == .small ? 170 : item.size == .medium ? 350 : 500,
                    height: item.size == .small ? 170 : item.size == .medium ? 170 : 250
                )
                .clipShape(RoundedRectangle(cornerRadius: 25))
            
            VStack(alignment: .leading) {
                HStack {
                    Text(item.title)
                        .padding(.top, 20)
                        .padding(.leading, 10)
                        .foregroundStyle(textColor)
                        .font(.title3)
                        .fontWeight(.heavy)
                    Spacer()
                }
                Spacer()
                VStack(alignment: .leading, spacing: 0) {
                    ZStack(alignment: .leading) {
                        UnevenRoundedRectangle(cornerRadii: .init(bottomTrailing: 25))
                            .frame(width: item.size == .small ? 170 * 0.9 : 350 * 0.9, height: 30)
                            .foregroundStyle(.red)
                        Text("\(timeRemaining.days) days")
                            .font(.title3)
                            .foregroundStyle(textColor)
                            .fontWeight(.light)
                            .padding(.leading, 15)
                    }
                    ZStack(alignment: .leading) {
                        UnevenRoundedRectangle(cornerRadii: .init(bottomTrailing: 25))
                            .frame(width: item.size == .small ? 170 * 0.5 : 350 * 0.5, height: 30)
                            .foregroundStyle(.green)
                        Text("\(timeRemaining.hours) hrs")
                            .font(.title3)
                            .foregroundStyle(textColor)
                            .fontWeight(.light)
                            .padding(.leading, 15)
                    }
                    ZStack(alignment: .leading) {
                        UnevenRoundedRectangle(cornerRadii: .init(bottomLeading: 25, bottomTrailing: 25))
                            .frame(width: item.size == .small ? 170 * 0.7 : 350 * 0.7, height: 30)
                            .foregroundStyle(.indigo)
                        Text("\(timeRemaining.minutes) min")
                            .font(.title3)
                            .foregroundStyle(textColor)
                            .fontWeight(.light)
                            .padding(.leading, 15)
                    }
                }
            }
        }
        .frame(
            width: item.size == .small ? 170 : item.size == .medium ? 350 : 500,
            height: item.size == .small ? 170 : item.size == .medium ? 170 : 250
        )
    }
}

