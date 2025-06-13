//
//  WidgetSizePreview.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 19.03.2025.
//

import SwiftUI

struct WidgetSizePreview: View {
    @ObservedObject var viewModel: CountDownSettingsViewModel
    let styleIndex: Int
    @Binding var sizeIndex: Int
    let title: String
    let backgroundColor: Color
    let textColor: Color
    let backgroundImageData: String?

    private func previewWidget(for size: WidgetSize) -> PetiverseWidgetItem {
        PetiverseWidgetItem(
            type: .countdown,
            title: title,
            backgroundColor: backgroundColor.description,
            textColor: textColor.description,
            backgroundImageData: backgroundImageData,
            size: size,
            countdownStyle: CountdownStyle(rawValue: styleIndex),
            targetDate: viewModel.targetDate
        )
    }

    var body: some View {
        TabView(selection: $sizeIndex) {
            // Small
            ZStack {
                previewForStyle(widget: previewWidget(for: .small))
                Text("Small")
                    .font(.caption)
                    .padding(4)
                    .background(Color.black.opacity(0.7))
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .offset(y: -60)
            }
            .tag(0)

            // Medium
            ZStack {
                previewForStyle(widget: previewWidget(for: .medium))
                Text("Medium")
                    .font(.caption)
                    .padding(4)
                    .background(Color.black.opacity(0.7))
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .offset(y: -60)
            }
            .tag(1)

            // Large
            ZStack {
                previewForStyle(widget: previewWidget(for: .large))
                Text("Large")
                    .font(.caption)
                    .padding(4)
                    .background(Color.black.opacity(0.7))
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .offset(y: -60)
            }
            .tag(2)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .frame(height: 250)
        .background(Color.gray.opacity(0.2)) // Arka planı netleştirmek için
    }

    @ViewBuilder
    func previewForStyle(widget: PetiverseWidgetItem) -> some View {
        switch widget.countdownStyle {
        case .style1:
            CountdownWidgetPreviewDesignOne(
                item: widget,
                timeRemaining: viewModel.timeRemaining,
                backgroundColor: backgroundColor,
                textColor: textColor
            )
        case .style2:
            CountdownWidgetPreviewDesignTwo(
                item: widget,
                timeRemaining: viewModel.timeRemaining,
                backgroundColor: backgroundColor,
                textColor: textColor
            )
        case .style3:
            CountdownWidgetPreviewDesignThree(
                item: widget,
                timeRemaining: viewModel.timeRemaining,
                backgroundColor: backgroundColor,
                textColor: textColor
            )
        case .style4:
            CountdownWidgetPreviewDesignFour(
                item: widget,
                timeRemaining: viewModel.timeRemaining,
                backgroundColor: backgroundColor,
                textColor: textColor
            )
        case .none:
            Text("No style selected")
                .background(backgroundColor)
                .foregroundStyle(textColor)
        }
    }

    func uiImage(from image: Image) -> UIImage? {
        let controller = UIHostingController(rootView: image)
        let view = controller.view
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 170, height: 170))
        return renderer.image { _ in
            view?.drawHierarchy(in: renderer.format.bounds, afterScreenUpdates: true)
        }
    }
}
