//
//  idgetBackgroundPhotoPickerView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 2.12.2024.
//

import Foundation
import SwiftUI
import PhotosUI

struct WidgetBackgroundPhotoPickerView : View {
    @ObservedObject var viewModel: CountDownSettingsViewModel
    @Binding var styleIndex : Int
    @Binding var selectedBackgroundPhoto : PhotosPickerItem?
    @Binding var backgroundImage : Image
    var body: some View {
        if styleIndex != 2 {
            PhotosPicker(selection: $selectedBackgroundPhoto, matching: .images) {
                HStack {
                    Text("Select a background photo")
                    Spacer()
                    Image(systemName: "photo.on.rectangle.angled")
                }.padding(.horizontal)
            }
            .onChange(of: selectedBackgroundPhoto) {
                Task {
                    if let loaded = try? await selectedBackgroundPhoto?.loadTransferable(type: Image.self) {
                        backgroundImage = loaded
                        // Set the selected background image for all items
                        for index in viewModel.itemsOne.indices {
                            viewModel.itemsOne[index].backgroundImage = loaded
                            viewModel.itemsOne[index].bgSelected = true
                            viewModel.itemsTwo[index].backgroundImage = loaded
                            viewModel.itemsTwo[index].bgSelected = true
                            viewModel.itemsFour[index].backgroundImage = loaded
                            viewModel.itemsFour[index].bgSelected = true
                        }
                    } else {
                        print("failed")
                    }
                }
            }
        }
    }
}
