//
//  CountDownWidgetTwo.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 11.10.2024.
//

import Foundation
import SwiftUI

struct CountdownWidgetPreviewDesignTwo: View {
    let item: PetiverseWidgetItem
    let timeRemaining: (days: Int, hours: Int, minutes: Int)
    let backgroundColor: Color
    let textColor: Color
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
                    width: item.size == .small ? 170 : item.size == .medium ? 350 : 500,
                    height: item.size == .small ? 170 : item.size == .medium ? 170 : 250
                ).clipShape(RoundedRectangle(cornerRadius: 25))
            }
            
            VStack(alignment: .leading) {
                HStack(alignment: .bottom) {
                    Text(item.title)
                        .padding(.top, 20)
                        .padding(.leading, 10)
                        .foregroundStyle(textColor)
                        .font(.title3)
                        .fontWeight(.heavy)
                    Spacer()
                }
                Spacer()
                HStack(alignment: .bottom) {
                    Text("\(timeRemaining.days)")
                        .font(.system(size: 60))
                        .bold()
                        .foregroundStyle(textColor)
                        .padding(.leading)
                        .offset(y: 10)
                    Text("Days")
                        .font(.title)
                        .foregroundStyle(textColor)
                        .fontWeight(.light)
                    Spacer()
                }
                .padding(.bottom, 10)
            }
        }
        .frame(
            width: item.size == .small ? 170 : item.size == .medium ? 350 : 500,
            height: item.size == .small ? 170 : item.size == .medium ? 170 : 250
        )
    }
}

