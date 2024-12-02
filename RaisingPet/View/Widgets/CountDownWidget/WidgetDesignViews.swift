//
//  WidgetDesignViews.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 2.12.2024.
//

import Foundation
import SwiftUI


struct WidgetDesignViews: View {
    @ObservedObject var viewModel: CountDownSettingsViewModel
    @Binding var styleIndex: Int
    @Binding var title: String
    
    private var items: [Any] {
        switch styleIndex {
        case 0: return viewModel.itemsOne
        case 1: return viewModel.itemsTwo
        case 2: return viewModel.itemsThree
        case 3: return viewModel.itemsFour
        default: return []
        }
    }
    
    var body: some View {
        TabView {
            ForEach(items.indices, id: \.self) { index in
                let item = items[index]
                if let itemOne = item as? CountDownWidgetOne {
                    CountDownWidgetPreviewDesignOne(
                        item: itemOne,
                        targetDate: Binding(
                            get: { viewModel.targetDate },
                            set: { viewModel.targetDate = $0 }
                        ),
                        timeRemaining: viewModel.timeRemaining,
                        title: $title
                    )
                } else if let itemTwo = item as? CountDownWidgetTwo {
                    CountDownWidgetPreviewDesignTwo(
                        item: itemTwo,
                        targetDate: Binding(
                            get: { viewModel.targetDate },
                            set: { viewModel.targetDate = $0 }
                        ),
                        timeRemaining: viewModel.timeRemaining,
                        title: $title
                    )
                }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .frame(height: 250)
        .background(Color.gray.gradient.opacity(0.1))
    }
}
