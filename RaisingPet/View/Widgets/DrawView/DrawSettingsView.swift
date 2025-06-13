//
//  DrawSettingsView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 4.11.2024.
//

import SwiftUI

struct DrawSettingsView: View {
    @State var selectedIndex: Int = 0

    var body: some View {
        NavigationStack {
            ZStack {
                WidgetSettingsBackground()
                VStack {
//                    TabView(selection : $selectedIndex) {
//                        ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
//                            DrawWidgetPreviewDesign(item: item)
//                                .tag(index)
//                        }
//                    }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
//                        .frame(height: selectedIndex == items.count - 1 ? 450 : 250)
//                        .animation(.bouncy(duration: 0.5), value: selectedIndex)
//                        .background(Color.gray.gradient.opacity(0.1))
                }
            }

        }
    }
}

#Preview {
    DrawSettingsView()
}
