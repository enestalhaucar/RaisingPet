//
//  ShareSheet.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 22.09.2024.
//

import Foundation
import SwiftUI

struct ShareSheet : UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let viewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        viewController.completionWithItemsHandler = {(_,_,_,_) in
            presentationMode.wrappedValue.dismiss()
        }
        return viewController
        
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
    
}

