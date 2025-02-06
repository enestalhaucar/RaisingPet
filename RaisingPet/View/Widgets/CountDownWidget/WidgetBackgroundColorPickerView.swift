//
//  WidgetBackgroundColorPickerView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 2.12.2024.
//

import Foundation
import SwiftUI

struct WidgetBackgroundColorPickerView : View {
    @ObservedObject var viewModel: CountDownSettingsViewModel
    @Binding var backgroundColor : Color
   
    var body : some View {
        ColorPicker("Select background color", selection: $backgroundColor)
            .padding(.horizontal)
            .onChange(of: backgroundColor) { _ in
                for index in viewModel.itemsOne.indices {
                    viewModel.itemsOne[index].backgroundColor = backgroundColor
                    viewModel.itemsOne[index].bgSelected = false // Deselect photo when color is picked
                    viewModel.itemsTwo[index].backgroundColor = backgroundColor
                    viewModel.itemsTwo[index].bgSelected = false // Deselect photo when color is picked
                    viewModel.itemsThree[index].backgroundColor = backgroundColor
                    viewModel.itemsFour[index].backgroundColor = backgroundColor
                    viewModel.itemsFour[index].bgSelected = false // Deselect photo when color is picked
                    
                }
            }
    }
}
