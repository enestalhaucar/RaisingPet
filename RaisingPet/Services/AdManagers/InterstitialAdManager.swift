//
//  InterstitialAdManager.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 8.06.2025.
//


import GoogleMobileAds
import SwiftUI



class InterstitialAdManager : NSObject, FullScreenContentDelegate, ObservableObject {
    private var interstitialAd: InterstitialAd?
    
    func loadAd() async {
        do {
            interstitialAd = try await InterstitialAd.load(
                with: "ca-app-pub-4692145739850693/4907187601", request: Request())
            interstitialAd?.fullScreenContentDelegate = self
        } catch {
            print("Failed to load interstitial ad with error: \(error.localizedDescription)")
        }
    }
    
    func showAd() {
        guard let interstitialAd = interstitialAd else {
            return print("Ad wasn't ready.")
        }
        
        interstitialAd.present(from: nil)
    }
}

