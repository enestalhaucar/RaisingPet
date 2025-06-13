//
//  PetItemPackageSection.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 8.06.2025.
//

import SwiftUI

struct PetItemPackageSection: View {
    let packages: [PetItemPackage]
    let onSelect: (PetItemPackage) -> Void
    @EnvironmentObject var currentUserVM: CurrentUserViewModel

    var body: some View {
        SectionHeader(title: "shop_section_pet_item_packages")

        ThreeColumnGrid(items: packages, id: \.id) { pkg in
            let state = packageState(for: pkg)

            ShopItemView(
                imageName: pkg.name ?? "petPackagePlaceholder",
                goldCost: nil,
                diamondCost: nil,
                price: state.priceText
            ) {
                if state.isTappable {
                    onSelect(pkg)
                }
            }
            .opacity(state.isTappable ? 1.0 : 0.6)
            .overlay(
                !state.isTappable ?
                    RoundedRectangle(cornerRadius: 10).fill(Color.black.opacity(0.2))
                    : nil
            )
        }
    }

    // NOT: Bu durum hesaplaması, `User` modelinde `packageClaimDates: [String: Date]?`
    // ve `role: String?` alanlarının olduğunu varsayar.
    private typealias PackageState = (isTappable: Bool, priceText: String)

    private func packageState(for pkg: PetItemPackage) -> PackageState {
        guard let user = currentUserVM.user, let packageId = pkg.id else {
            return (false, "...")
        }

        let name = pkg.name ?? ""

        if name.contains("Ad") {
            return (true, "Reklam İzle")
        }

        if name.contains("Premium") {
            if user.role != "premium" {
                return (false, "Premium")
            }
        }

        // Free ve Premium paketler için bekleme süresi kontrolü
        if let lastClaimDate = user.packageClaimDates?[packageId] {
            let cooldown: TimeInterval = 24 * 60 * 60
            let nextDate = lastClaimDate.addingTimeInterval(cooldown)
            if Date() < nextDate {
                let remaining = nextDate.timeIntervalSince(Date())
                return (false, format(duration: remaining))
            }
        }

        let price = name.contains("Free") ? "Ücretsiz" : "Al"
        return (true, price)
    }

    private func format(duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: duration) ?? "00:00:00"
    }
}
