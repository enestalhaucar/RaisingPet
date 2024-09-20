//
//  NoteView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 5.08.2024.
//

import SwiftUI
import PencilKit


struct NoteView: View {
    var body: some View {
        SignatureView()
    }
}

struct SignatureView : View {
    @State private var canvasView = PKCanvasView()
    @State private var showingShareSheet = false
    @State private var showAlert = false
    @State private var signatureImage : UIImage?
    @State private var penColor : UIColor = .black
    @State private var colorSelection : Color = .black
    @State var lineSizeValues : [Double] = [1,2,4,8,16]
    @State var circleSizeValues : [Double] = [0.2, 0.4, 0.6, 0.8, 1]
    @State private var currentIndex : Int = 0
    @Environment(\.undoManager) private var undoManager
    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                Spacer()
                PKCanvasRepresentation(canvasView : $canvasView, penColor: $penColor, lineSize: $lineSizeValues[currentIndex])
                    .frame(height: 300)
                    .border(Color.gray, width: 1)
                    .padding()
                
                HStack {
                    Spacer()
                    Button {
                        
                    } label: {
                        Image(systemName : "pawprint")
                            .font(.system(size: 35))
                    }
                    Spacer()
                    Button {
                        
                    } label: {
                        Image(systemName : "photo")
                            .font(.system(size: 35))
                    }
                    Spacer()
                    Button {
                        signatureImage = canvasView.asImage()
                        if let image = signatureImage {
                            saveImageToGallery(image: image)
                        }
                        showAlert = true
                    } label: {
                        Image(systemName : "camera")
                            .font(.system(size: 35))
                    }
                    Spacer()
                    
                }
                
                
                
                HStack {
                    HStack(spacing: 20) {
                        Button(action: {
                            canvasView.drawing = PKDrawing()
                        }) {
                            Text("Clear")
                                .font(.title3)
                        }
                        HStack(spacing: 10) {
                            Button(action: {
                                undoManager?.undo()
                            }) {
                                Image(systemName: "arrow.uturn.backward")
                                    .font(.system(size: 25))
                            }
                            
                            Button(action: {
                                undoManager?.redo()
                            }) {
                                Image(systemName: "arrow.uturn.forward")
                                    .font(.system(size: 25))
                            }
                        }
                        
                        
                        
                        Spacer()
                        Spacer()
                        Spacer()
                        
                        HStack {
                            Button("-") {
                                currentIndex = (currentIndex - 1 + lineSizeValues.count) % lineSizeValues.count
                            }
                            
                            Circle()
                                .scaleEffect(circleSizeValues[currentIndex])
                                .foregroundStyle(colorSelection)
                            
                            
                            Button("+") {
                                currentIndex = (currentIndex + 1) % lineSizeValues.count
                            }
                        }.onChange(of: currentIndex) { oldValue, newValue in
                            canvasView.tool = PKInkingTool(.pen, color: UIColor(colorSelection), width: lineSizeValues[currentIndex])
                        }
                        
                        ColorPicker("", selection: $colorSelection , supportsOpacity: true)
                            .padding()
                            .onChange(of: colorSelection) { oldValue, newValue in
                                canvasView.tool = PKInkingTool(.pen, color: UIColor(colorSelection), width: lineSizeValues[currentIndex])
                            }
                            .scaleEffect(1.2)
                        
                        
                        
                        
                    }.frame(height: 30)
                        .padding()
                        .sheet(isPresented: Binding(get: { showingShareSheet },
                                                    set: { showingShareSheet = $0 })) {
                            if let image = signatureImage {
                                ShareSheet(activityItems: [image])
                                
                            }
                        }
                }
                .background(Color.yellow.opacity(0.4))
                Spacer()
                
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        signatureImage = canvasView.asImage()
                        showingShareSheet = true
                    } label: {
                        Image(systemName: "paperplane")
                    }
                    
                    
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Başarılı"), message: Text("Fotoğraf başarılı bir şekilde kaydedildi."), dismissButton: .default(Text("OK")))
            }
        }
    }
    func saveImageToGallery(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}



struct PKCanvasRepresentation : UIViewRepresentable {
    @Binding var canvasView : PKCanvasView
    @Binding var penColor : UIColor
    @Binding var lineSize : Double
    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.tool = PKInkingTool(.pencil, color: .black, width: 1)
        canvasView.drawingPolicy = .anyInput
        canvasView.backgroundColor = .clear
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        
    }
}

struct ShareSheet : UIViewControllerRepresentable {
    let activityItems : [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return controller
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        
    }
}


extension PKCanvasView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { context in
            drawHierarchy(in: bounds, afterScreenUpdates: true)
        }
    }
}


#Preview {
    NoteView()
}
