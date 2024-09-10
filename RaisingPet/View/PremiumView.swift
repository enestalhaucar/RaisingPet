//
//  PremiumView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 6.09.2024.
//

import SwiftUI

struct PremiumView: View {
    @Binding var isShow : Bool
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 25) {
                VStack {
                    HStack {
                        Image("Diamond")
                            .resizable()
                            .frame(width: 40,height: 40)
                        Text("Petiverse Premium")
                            .font(.title2)
                    }
                    
                    Text("Try free trial with 3 days")
                        .font(.caption)
                }
                
                Image("premiumPhoto")
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image("premiumBell")
                        Text("Use without Ads ").font(.title2)
                    }
                    HStack {
                        Image("premiumEgg")
                        Text("Special Charachters").font(.title2)
                    }
                    HStack {
                        Image("premiumPet")
                        Text("Customized Events").font(.title2)
                    }
                    
                }
                Spacer()
                upgradeButton(title: "Monthly", dollar: "10", timePeriod: "Month")
                upgradeButton(title: "Yearly", dollar: "20", timePeriod: "Month")
                upgradeButton(title: "Lifetime", dollar: "30", timePeriod: "Lifetime")
                
                
                
            }.toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        isShow = false
                    }, label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 20,height: 20)
                            .foregroundStyle(.black)
                    })
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        PremiumView(isShow: .constant(false))
    }
}


struct upgradeButton : View {
    var title : String
    var dollar : String
    var timePeriod : String
    var body: some View {
        Button(action: {
            // Butona tıklandığında yapılacak işlemler
        }) {
            HStack {
                 
                // Metin
                Text(title)
                    .font(.system(size: 20))
                    .foregroundColor(.black)
                
                Spacer()
                
                Text("\(dollar)$ / \(timePeriod)")
                
                
            }.frame(width: UIScreen.main.bounds.width * 7 / 10, height: 40)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color(red: 255/255, green: 245/255, blue: 235/255)) // İç dolgu rengi
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(
                                    LinearGradient(gradient: Gradient(colors: [
                                        Color(red: 94/255, green: 92/255, blue: 230/255), // İlk renk: #5E5CE6
                                        Color(red: 255/255, green: 55/255, blue: 95/255), // Orta renk: #FF375F
                                        Color(red: 255/255, green: 159/255, blue: 10/255)  // Son renk: #FF9F0A
                                    ]), startPoint: .leading, endPoint: .trailing),
                                    lineWidth: 2 // Çerçeve kalınlığı
                                )
                        )
                )
        }
    }
}
