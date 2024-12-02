//
//  WidgetTextColorPickerView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 2.12.2024.
//

import Foundation
import SwiftUI

struct WidgetTextColorPickerView : View {
    @ObservedObject var viewModel: CountDownSettingsViewModel
    @Binding var textColor : Color
    var body: some View {
        ColorPicker("Select text color", selection: $textColor)
            .padding(.horizontal)
            .onChange(of: textColor) {
                for index in viewModel.itemsOne.indices {
                    viewModel.itemsOne[index].textColor = textColor
                    viewModel.itemsTwo[index].textColor = textColor
                    viewModel.itemsThree[index].textColor = textColor
                    viewModel.itemsFour[index].textColor = textColor
                }
            }
        
    }
}
