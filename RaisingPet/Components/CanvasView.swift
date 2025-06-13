//
//  CanvasView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 22.09.2024.
//

import SwiftUI
import PencilKit

struct CanvasView {
    @Binding var canvasView: PKCanvasView
    @State private var toolPicker = PKToolPicker()
    @Binding var backgroundColor: UIColor
    func makeUIView(context: Context) -> PKCanvasView {
        // Varsayılan çizim aracını ayarlıyoruz:
        canvasView.tool = PKInkingTool(.pen, color: .purple, width: 10)
        // Parmak ile çizime izin veriyoruz
        canvasView.drawingPolicy = .anyInput
        canvasView.backgroundColor = backgroundColor
        showToolPicker()
        return canvasView
    }

}
extension CanvasView: UIViewRepresentable {
    func updateUIView(_ uiView: PKCanvasView, context: Context) { }
}

private extension CanvasView {
    // Araç takımını gösteren metot
    func showToolPicker() {
        // CanvasView aktifken araç takımını göster
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        // CanvasView görünümünü araç değişiminde güncelle
        toolPicker.addObserver(canvasView)
        // CanvasView görünümünü ana görünüm yap
        canvasView.becomeFirstResponder()
    }
}

#Preview {
    CanvasView(canvasView: .constant(PKCanvasView()), backgroundColor: .constant(.cyan))
}
