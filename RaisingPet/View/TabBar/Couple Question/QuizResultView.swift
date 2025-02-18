//
//  QuizResultView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 17.02.2025.
//

import SwiftUI

struct QuizResultView: View {
    let selectedAnswers: [String]
    @State var percentage : Double = 0.0
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Birbirimize bu kadar iyi uyum sağlıyoruz!")
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding()
                    
//                    Text(String(format: "%.0f%%", percentage * 100))
//                        .font(.largeTitle)
//                        .bold()
//                        .foregroundColor(.blue)
                    
                    VStack(spacing: 15) {
                        ForEach(selectedAnswers.indices, id: \ .self) { index in
                            HStack {
                                Text(selectedAnswers[index])
                                    .frame(maxWidth: .infinity)
                                    .padding(10)
                                    .background(Color.blue.opacity(0.2))
                                    .cornerRadius(10)
                                
                                Text("VS")
                                    .font(.nunito(.medium, .title320))
                                    .bold()
                                    .padding(.horizontal, 8)
                                
                                Text("?")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue.opacity(0.2))
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding()
                    
                    Button(action: {  }) {
                        Text("Testi Tekrar Çöz")
                            .frame(width: 200, height: 50)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }

            }
        }.onAppear {
            self.percentage = calculateMatchPercentage()
        }
    }
    
    private func calculateMatchPercentage() -> Double {
        return Double(selectedAnswers.count) / 15.0 // Örnek bir hesaplama
    }
}

