//
//  WidgetTextColorPickerView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 2.12.2024.
//

import SwiftUI

struct WidgetTextColorPickerView: View {
    @Binding var textColor: Color
    
    var body: some View {
        ColorPicker("Select text color", selection: $textColor)
            .padding(.horizontal)
    }
}
