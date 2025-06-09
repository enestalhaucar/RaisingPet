//
//  AnimatedPetView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 3.06.2025.
//

import SwiftUI
import Lottie

struct AnimatedPetView: View {
    let petTypeName: String
    
    // JSON dosya adını petTypeName'e göre belirle (Bundle için)
    private var jsonFileName: String? {
        switch petTypeName.lowercased() {
        case "dalmatian": return "dalmacian_idle"
        case "cat": return "cat_idle"
        case "fox": return "fox_idle"
        default: return nil
        }
    }
    
    // Static image adını belirle (PetsImage klasöründeki isimler)
    private var staticImageName: String {
        switch petTypeName.lowercased() {
        case "dalmatian": return "dalmacian"
        case "cat": return "cat"
        case "fox": return "fox"
        case "dog": return "dog"
        case "shiba": return "shiba"
        case "duck": return "duck"
        case "frog": return "frog"
        case "panda": return "panda"
        default: return "dog" // fallback
        }
    }
    
    var body: some View {
        Group {
            if let jsonFileName = jsonFileName {
                // JSON animasyon varsa göster
                LottieView(animation: .named(jsonFileName))
                    .playbackMode(.playing(.fromProgress(0, toProgress: 1, loopMode: .loop)))
                    .frame(width: 120, height: 120)
            } else {
                // JSON yoksa static resim göster
                Image(staticImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
            }
        }
    }
}

#Preview {
    AnimatedPetView(petTypeName: "cat")
}
