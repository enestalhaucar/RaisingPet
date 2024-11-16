//
//  DrawWidgetOne.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 4.11.2024.
//

import SwiftUI

struct DrawWidget : Identifiable, Equatable {
    var id = UUID()
    var size : widgetSizeOne
    var backgroundImage : Image
    var drawSelected : Bool = false

    
}

struct DrawWidgetPreviewDesign: View {
    let item : DrawWidget
    var body: some View {
        ZStack {
            if item.drawSelected  {
                Color.blue.opacity(0.3)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
            }
        }.frame(width: item.size == .small ? 170 : 350, height: item.size == .large ? 350 : 170)
        
    }
}

#Preview {
    DrawSettingsView()
}
