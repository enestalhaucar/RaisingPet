//
//  EggCellView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 7.05.2025.
//

import SwiftUI

struct EggCellView: View {
    let item: InventoryItem
    let onHatch: () -> Void

    @State private var now = Date()
    @State private var isPressed = false // Animasyon için

    private let iso: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return f
    }()

    private var acquiredAt: Date? {
        iso.date(from: item.acquiredAt ?? "")
    }
    private var crackedAt: Date? {
        iso.date(from: item.properties.egg?.crackedAt ?? "")
    }

    private var totalInterval: TimeInterval {
        guard let a = acquiredAt, let c = crackedAt else { return 1 }
        return c.timeIntervalSince(a)
    }
    private var elapsed: TimeInterval {
        guard let a = acquiredAt else { return 0 }
        return now.timeIntervalSince(a)
    }
    private var progress: Double {
        guard totalInterval > 0 else { return 1 }
        return min(max(elapsed / totalInterval, 0), 1)
    }
    private var remaining: TimeInterval {
        guard let c = crackedAt else { return 0 }
        return max(c.timeIntervalSince(now), 0)
    }

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("EggBackgroundColor"))
                    .frame(width: 80, height: 90)
                    .shadow(radius: 4) // Gölge eklendi
                Image(item.itemId.name)
                    .resizable()
                    .frame(width: 40, height: 40)
            }

            if remaining > 0 {
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.gray.opacity(0.2)) // Daha soft arka plan
                        .frame(width: 80, height: 6)
                    Capsule()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.green, .blue]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        ) // Degrade renk
                        .frame(width: CGFloat(progress * 80), height: 6)
                        .animation(.easeInOut, value: progress) // Animasyonlu geçiş
                }
                Text(timeString(from: remaining))
                    .font(.caption2)
                    .foregroundColor(.gray)
            } else {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isPressed = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        isPressed = false
                        onHatch()
                    }
                }) {
                    Text("egg_pets_hatch_pets".localized())
                        .font(.subheadline)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
                .scaleEffect(isPressed ? 0.95 : 1.0) // Basıldığında küçülme efekti
            }
        }
        .onReceive(Timer.publish(every: 1, on: .main, in: .common)
                    .autoconnect()) { self.now = $0 }
    }

    private func timeString(from interval: TimeInterval) -> String {
        let s = Int(interval)
        let h = s / 3600, m = (s % 3600) / 60, sec = s % 60
        return String(format: "%02d:%02d:%02d", h, m, sec)
    }
}
