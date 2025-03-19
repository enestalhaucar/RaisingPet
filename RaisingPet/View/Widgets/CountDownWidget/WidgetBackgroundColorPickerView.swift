//
//  WidgetBackgroundColorPickerView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 2.12.2024.
//

import SwiftUI

struct WidgetBackgroundColorPickerView: View {
    @Binding var backgroundColor: Color
    
    var body: some View {
        ColorPicker("Select background color", selection: $backgroundColor)
            .padding(.horizontal)
    }
}
