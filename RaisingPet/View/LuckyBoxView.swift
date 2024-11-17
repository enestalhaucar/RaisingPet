

import SwiftUI

struct LuckyBoxView: View {
    @State private var selectedPrize: String? // Seçilen ödül
    @State private var isRevealed: Bool = false // Ödülün gösterilip gösterilmediği

    let prizes = ["Gold", "Diamond", "Silver", "Ruby", "Emerald", "Sapphire", "Amethyst", "Pearl", "Topaz"]

    var body: some View {
        NavigationStack {
            ZStack {
                Image("luckyDrawBackground")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack(spacing: 25) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 25.0)
                            .foregroundStyle(.white.opacity(0.7))
                        
                        GiftBoxView(prizes: prizes, onBoxSelected: { prize in
                            withAnimation {
                                selectedPrize = prize
                                isRevealed = true
                            }
                        })
                        
                    }.frame(width: 320, height: 320)
                        .padding(.top, 30)

                    DRAWButtonView {
                        selectRandomPrize()
                    }

                    DailyTaskView()

                    Spacer()
                }
                .navigationTitle("Lucky Draw")
                .navigationBarTitleDisplayMode(.inline)
                .overlay(
                    PrizeRevealView(prize: selectedPrize, isRevealed: $isRevealed)
                )
            }
        }
    }

    func selectRandomPrize() {
        selectedPrize = prizes.randomElement()
        isRevealed = true
    }
}

struct GiftBoxView: View {
    let prizes: [String]
    let onBoxSelected: (String) -> Void

    var body: some View {
        Grid(alignment: .center, horizontalSpacing: 50, verticalSpacing: 30) {
            ForEach(0..<3, id: \.self) { row in
                GridRow {
                    ForEach(0..<3, id: \.self) { column in
                        let prizeIndex = row * 3 + column
                        let prize = prizes[prizeIndex]
                        Button {
                            onBoxSelected(prize)
                        } label: {
                            VStack(spacing: 10) {
                                Image("giftBox")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                Text("Prize")
                                    .font(.caption)
                            }
                        }
                    }
                }
            }
        }
        .padding(20)
    }
}

struct DRAWButtonView: View {
    var onDraw: () -> Void

    var body: some View {
        Button {
            onDraw()
        } label: {
            ZStack {
                Circle()
                    .fill(.white.opacity(0.7))
                    .frame(width: 75, height: 75)
                
                Text("DRAW!")
                    .bold()
            }
        }
    }
}

struct DailyTaskView: View {
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .foregroundStyle(.white.opacity(0.7))
                VStack(spacing: 20) {
                    HStack {
                        Text("Tasks").bold().font(.title2)
                        Spacer()
                        Text("Renewal Period : 24Hr").font(.caption)
                    }.padding()

                    VStack(spacing: 10) {
                        ForEach(1...3, id: \.self) { index in
                            HStack {
                                Text("Task \(index)")
                                Spacer()
                                Text("Completed")
                                    .font(.caption2)
                                    .padding(.vertical, 5)
                                    .padding(.horizontal)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 25.0)
                                            .stroke(.gray, lineWidth: 1)
                                    }
                            }.padding(.horizontal)
                        }
                    }
                    Spacer()
                }
            }.frame(width: 320)
        }
    }
}

struct PrizeRevealView: View {
    let prize: String?
    @Binding var isRevealed: Bool

    var body: some View {
        if isRevealed, let prize = prize {
            ZStack {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Text("Congratulations!")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                    
                    Text("You won a \(prize)!")
                        .font(.title2)
                        .foregroundColor(.yellow)

                    Button("Close") {
                        withAnimation {
                            isRevealed = false
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                }
                .padding()
                .background(Color.black.opacity(0.8))
                .cornerRadius(15)
            }
            .transition(.scale)
        }
    }
}

#Preview {
    LuckyBoxView()
}
