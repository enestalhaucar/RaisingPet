//
//  NoteView2.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 21.09.2024.
//

import SwiftUI
import PencilKit

struct NoteView: View {
    @State private var canvasView = PKCanvasView()
    @State private var showingdeleteConfirmation = false
    @State private var showingShareSheet = false
    @Environment(\.undoManager) private var undoManager
    @State var backgroundColor: UIColor = .white
    @State private var path = NavigationPath()
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                VStack(spacing: 20) {
                    CanvasView(canvasView: $canvasView, backgroundColor: $backgroundColor)
                        .frame(height: 400)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .overlay {
                            RoundedRectangle(cornerRadius: 25.0)
                                .stroke(Color.gray.gradient, lineWidth: 3)
                        }
                        
                    HStack {
                        Image(systemName: "pawprint").font(.system(size: 30))
                        Image(systemName: "photo").font(.system(size: 30))
                        Image(systemName: "camera").font(.system(size: 30))
                        Spacer()
                        Button(action: {
                            if let inkingTool = canvasView.tool as? PKInkingTool {
                                backgroundColor = inkingTool.color
                                canvasView.backgroundColor = backgroundColor
                            }
                        }, label: {
                            Image(systemName: "paintbrush").font(.system(size: 30))
                        })
                    }
                }.padding()
                    .padding(.horizontal)
                
            }.navigationBarBackButtonHidden()
            .sheet(isPresented: $showingShareSheet, content: {
                ShareSheet(activityItems: [canvasView.drawing.image(from: canvasView.bounds, scale: UIScreen.main.scale)])
            })
            .toolbar(.visible, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showingdeleteConfirmation = true
                    }, label: {
                        Label("note_clear_button".localized(), systemImage: "trash")
                    }).confirmationDialog("note_clear_canvas".localized(), isPresented: $showingdeleteConfirmation) {
                        Button("note_clear_button".localized(), role: .destructive) {
                            canvasView.drawing = PKDrawing()
                        }
                        Button("note_cancel_button".localized(), role: .cancel) {}
                    } message: {
                        Text("note_clear_message".localized())
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingShareSheet = true
                    } label: {
                        Label("note_share_drawing".localized(), systemImage: "square.and.arrow.up")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink(destination: HomeView()) {
                        Image(systemName: "house")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        undoManager?.undo()
                    } label: {
                        Image(systemName: "arrow.uturn.backward")
                    }
                    
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        undoManager?.redo()
                    } label: {
                        Image(systemName: "arrow.uturn.forward")
                    }
                }
            }
        }
    }
}

#Preview {
    NoteView()
}
