//
//  PaywallView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 17.02.2025.
//


import SwiftUI
import Adapty
import AdaptyUI

struct PaywallView: View {
    @State private var paywall: AdaptyPaywall?
    @State private var isPaywallPresented = false
    
    var body: some View {
        VStack {
            Button("Paywall'ı Göster") {
//                fetchPaywall()
            }
        }
//        .paywall(
//            isPresented: $isPaywallPresented,
//            paywall: paywall,
//            onPurchase: { product, purchaserInfo in
//                // Satın alma işlemi başarılı
//                print("Satın alma başarılı: \(product.vendorProductId)")
//            },
//            onError: { error in
//                // Hata oluştu
//                print("Hata: \(error.localizedDescription)")
//            }
//        )
//        
    }
    
//    func fetchPaywall() {
//            Adapty.getPaywall(id: "YOUR_PAYWALL_ID") { result in
//                switch result {
//                case .success(let fetchedPaywall):
//                    self.paywall = fetchedPaywall
//                    self.isPaywallPresented = true
//                case .failure(let error):
//                    print("Paywall alınırken hata oluştu: \(error.localizedDescription)")
//                }
//            }
//        }
}
