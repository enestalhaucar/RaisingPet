import SwiftUI

struct LuckyBoxView: View {
    @State private var selectedPrize: String? // Seçilen ödül
    @State private var isRevealed: Bool = false // Ödülün gösterilip gösterilmediği
    @State private var currentHighlightIndex: Int? = nil // Hangi kutunun vurgulandığı
    @State private var isAnimating: Bool = false // Animasyon durumu
    @State private var prizeStates: [String: Bool] = [:] // Ödül durumu (seçildi mi?)

    let prizes = ["Gold", "Diamond", "Silver", "Ruby", "Emerald", "Sapphire", "Amethyst", "Pearl", "Topaz"]

    init() {
        // Ödül durumlarını başlangıçta "false" olarak ayarla
        _prizeStates = State(initialValue: Dictionary(uniqueKeysWithValues: prizes.map { ($0, false) }))
    }

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

                        GiftBoxView(prizes: prizes, currentHighlightIndex: currentHighlightIndex, prizeStates: prizeStates)
                    }
                    .frame(width: 320, height: 320)
                    .padding(.top, 30)

                    DRAWButtonView {
                        startAnimation()
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

    func startAnimation() {
        guard !isAnimating else { return } // Zaten animasyon çalışıyorsa başlatma
        guard prizeStates.contains(where: { !$0.value }) else { return } // Tüm ödüller seçilmişse animasyonu başlatma

        isAnimating = true
        var currentIndex = 0

        // Rastgele bir ödül seçilecek hedef index
        let availablePrizes = prizes.enumerated().filter { !prizeStates[$0.element]! }
        guard let randomTarget = availablePrizes.randomElement() else { return }
        let targetIndex = randomTarget.offset

        let totalDuration = 8.0
        let interval = 0.4
        let steps = Int(totalDuration / interval)
        var stepCount = 0

        Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
            withAnimation {
                currentHighlightIndex = currentIndex
            }

            currentIndex = (currentIndex + 1) % prizes.count
            stepCount += 1

            if stepCount >= steps || currentIndex == targetIndex {
                timer.invalidate()
                stopAnimation(targetIndex: targetIndex)
            }
        }
    }

    func stopAnimation(targetIndex: Int) {
        guard isAnimating else { return }
        isAnimating = false

        let selected = prizes[targetIndex]
        selectedPrize = selected
        isRevealed = true
        // Ödül seçildi olarak işaretle (opaklık için)
        prizeStates[selected] = true
    }

}

struct GiftBoxView: View {
    let prizes: [String]
    let currentHighlightIndex: Int?
    let prizeStates: [String: Bool]

    var body: some View {
        Grid(alignment: .center, horizontalSpacing: 50, verticalSpacing: 30) {
            ForEach(0..<3, id: \.self) { row in
                GridRow {
                    ForEach(0..<3, id: \.self) { column in
                        let prizeIndex = row * 3 + column
                        if prizeIndex < prizes.count {
                            let prize = prizes[prizeIndex]
                            let index = prizeIndex - 1
                            let isSelected = prizeStates[prize] ?? false
                            VStack(spacing: 10) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(currentHighlightIndex == index ? Color.yellow : Color.clear, lineWidth: 4)
                                        .frame(width: 60, height: 60)

                                    Image("giftBox")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .opacity(isSelected ? 0.3 : 1.0) // Seçildiyse opaklığı düşür
                                }
                                Text(prize)
                                    .font(.caption)
                                    .opacity(isSelected ? 0.5 : 1.0) // Seçildiyse metin opaklığı düşür
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

#Preview {
    LuckyBoxView()
}
