//
//  WidgetDesignViews.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 2.12.2024.
//

import SwiftUI

struct WidgetDesignViews: View {
    @ObservedObject var viewModel: CountDownSettingsViewModel
    @Binding var styleIndex: Int
    @Binding var title: String
    var backgroundColor: Color
    var textColor: Color
    var backgroundImageData: String?
    
    // Stil için örnek bir widget oluştur
    private func previewWidget(for style: CountdownStyle) -> PetiverseWidgetItem {
        PetiverseWidgetItem(
            type: .countdown,
            title: title,
            backgroundColor: backgroundColor.description,
            textColor: textColor.description,
            backgroundImageData: backgroundImageData,
            size: .small, // Varsayılan olarak small kullanıyoruz, çünkü bu preview
            countdownStyle: style,
            targetDate: viewModel.targetDate
        )
    }
    
    var body: some View {
        TabView(selection: $styleIndex) {
            // Stil 1
            CountdownWidgetPreviewDesignOne(
                item: previewWidget(for: .style1),
                timeRemaining: viewModel.timeRemaining,
                backgroundColor: backgroundColor,
                textColor: textColor
            )
            .tag(0)
            
            // Stil 2
            CountdownWidgetPreviewDesignTwo(
                item: previewWidget(for: .style2),
                timeRemaining: viewModel.timeRemaining,
                backgroundColor: backgroundColor,
                textColor: textColor
            )
            .tag(1)
            
            // Stil 3
            CountdownWidgetPreviewDesignThree(
                item: previewWidget(for: .style3),
                timeRemaining: viewModel.timeRemaining,
                backgroundColor: backgroundColor,
                textColor: textColor
            )
            .tag(2)
            
            // Stil 4
            CountdownWidgetPreviewDesignFour(
                item: previewWidget(for: .style4),
                timeRemaining: viewModel.timeRemaining,
                backgroundColor: backgroundColor,
                textColor: textColor
            )
            .tag(3)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .frame(height: 250)
        .background(Color.gray.gradient.opacity(0.1))
    }
    
    // Image’ı UIImage’e çevirme yardımcı fonksiyonu
    func uiImage(from image: Image) -> UIImage? {
        let controller = UIHostingController(rootView: image)
        let view = controller.view
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 170, height: 170))
        return renderer.image { _ in
            view?.drawHierarchy(in: renderer.format.bounds, afterScreenUpdates: true)
        }
    }
}
