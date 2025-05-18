//
//  HatchEggView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 21.05.2025.
//

import SwiftUI

struct HatchEggView: View {
    let item: InventoryItem
    let onClose: () -> Void
    let onHatch: (String) -> Void
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var friendsViewModel = FriendsViewModel()
    @State private var now = Date()
    @State private var isPressed = false
    @State private var userDetails: [String: String] = [:]
    @State private var friendName: String = ""
    
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
    
    private var isReadyToHatch: Bool {
        remaining <= 0
    }
    
    private var eggNameCapitalized: String {
        // Convert eggName to proper capitalized form
        return item.itemId.name.split(separator: " ").map { 
            $0.prefix(1).uppercased() + $0.dropFirst().lowercased() 
        }.joined(separator: " ")
    }
    
    // Function to get friend name
    private func updateFriendName() {
        // İlk olarak, kullanıcının kendi adını UserDefaults'tan al
        let currentUserName = userDetails["firstname"] ?? "User"
        
        // Eşleşen arkadaşı bul
        if let petId = item.properties.egg?.whichPetDidItComeFrom {
            // Başlangıçta arkadaş adını boş bırak ya da varsayılan değer ver
            friendName = "Friend"
            
            // Kabul edilen arkadaşlar listesinde ara
            for friend in friendsViewModel.acceptedFriends {
                // İsteğe göre ayarlanabilir - id kontrolü
                if friend.friend._id == petId || friend.id == petId {
                    friendName = friend.friend.firstname
                    return
                }
            }
        } else {
            // Eğer eşleşme yoksa varsayılan değer
            friendName = "Friend"
        }
        
        // Eğer friend hala boşsa, varsayılan "Friend" değerini kullan
        if friendName.isEmpty {
            friendName = "Friend"
        }
    }
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.green.opacity(0.2)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Top navigation bar
                HStack {
                    Button(action: {
                        dismiss()
                        onClose()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    
                    // Display only the egg name with capitalized first letters
                    Text(eggNameCapitalized)
                        .font(.nunito(.semiBold, .title222))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    // Empty spacer for symmetry
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.clear)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                Spacer()
                
                // Parent profile images
                if let _ = item.properties.egg?.whichPetDidItComeFrom {
                    HStack(spacing: 40) {
                        VStack {
                            // Kullanıcı profil resmi - sistem ikonu
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .foregroundColor(.blue)
                                .background(Color.white)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.yellow, lineWidth: 2)
                                )
                            // Kullanıcı adı
                            Text(userDetails["firstname"] ?? "User")
                                .font(.nunito(.medium, .body16))
                        }
                        
                        Image(systemName: "heart.fill")
                            .foregroundColor(.pink)
                            .font(.system(size: 20))
                        
                        VStack {
                            // Arkadaş profil resmi - farklı bir sistem ikonu
                            Image(systemName: "person.crop.circle.badge.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .foregroundColor(.green)
                                .background(Color.white)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.yellow, lineWidth: 2)
                                )
                            // Arkadaş adı
                            Text(friendName)
                                .font(.nunito(.medium, .body16))
                        }
                    }
                    .padding(.bottom, 20)
                }
                
                // Large egg image
                ZStack {
                    // Try to load the egg image with different approaches
                    if let eggImage = UIImage(named: item.itemId.name) {
                        Image(uiImage: eggImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .scaleEffect(isPressed ? 0.95 : 1.0)
                            .animation(.easeInOut(duration: 0.3), value: isPressed)
                    } else {
                        // Fallback to one of the known egg images
                        Image("Egg")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .scaleEffect(isPressed ? 0.95 : 1.0)
                            .animation(.easeInOut(duration: 0.3), value: isPressed)
                    }
                }
                .onTapGesture {
                    if isReadyToHatch {
                        withAnimation {
                            isPressed = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            isPressed = false
                            if let id = item.id {
                                onHatch(id)
                            }
                        }
                    }
                }
                
                // Timer display
                Text(timeString(from: remaining))
                    .font(.nunito(.bold, .title222))
                    .foregroundColor(isReadyToHatch ? .green : .primary)
                
                // Progress bar with blue gradient
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 16)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(red: 0.0, green: 0.7, blue: 1.0), Color(red: 0.0, green: 0.4, blue: 0.8)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: UIScreen.main.bounds.width * 0.8 * progress, height: 16)
                        .animation(.easeInOut, value: progress)
                }
                .frame(width: UIScreen.main.bounds.width * 0.8)
                
                Spacer()
                
                // Bottom action buttons
                HStack(spacing: 20) {
                    actionButton(
                        imageName: "stopwatch.fill",
                        text: "-6 hour",
                        action: { /* Swift action to reduce time by 6 hours */ },
                        hasBadge: true
                    )
                    
                    actionButton(
                        imageName: "flame.fill",
                        text: "-24 hour",
                        action: { /* Swift action to reduce time by 24 hours */ }
                    )
                    
                    actionButton(
                        imageName: "video.fill",
                        text: "-1 hour",
                        action: { /* Swift action to reduce time by 1 hour */ },
                        badgeText: "AD"
                    )
                }
                .padding(.bottom, 40)
                
            }
            .padding()
            .overlay {
                if friendsViewModel.isLoading {
                    ProgressView()
                }
            }
        }
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { 
            self.now = $0 
        }
        .onAppear {
            // Get user details from UserDefaults
            userDetails = Utilities.shared.getUserDetailsFromUserDefaults()
            
            // Fetch friends list and update friend name
            Task {
                await friendsViewModel.fetchFriendsList()
                updateFriendName()
            }
        }
        .navigationBarHidden(true)
    }
    
    // Helper function to create action buttons
    private func actionButton(
        imageName: String, 
        text: String, 
        action: @escaping () -> Void,
        hasBadge: Bool = false,
        badgeText: String = "FREE"
    ) -> some View {
        VStack {
            Button(action: action) {
                ZStack(alignment: .topTrailing) {
                    VStack {
                        Image(systemName: imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .padding(10)
                    }
                    .frame(width: 70, height: 70)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(10)
                    
                    if hasBadge {
                        Text(badgeText)
                            .font(.nunito(.bold, .xsmall))
                            .foregroundColor(.black)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.yellow)
                            .cornerRadius(10)
                            .offset(x: 5, y: -5)
                    }
                }
            }
            
            Text(text)
                .font(.nunito(.medium, .caption12))
                .foregroundColor(.primary)
        }
    }
    
    private func timeString(from interval: TimeInterval) -> String {
        if interval <= 0 {
            return "Ready to Hatch!"
        }
        
        let s = Int(interval)
        let h = s / 3600, m = (s % 3600) / 60, sec = s % 60
        return String(format: "%02d:%02d:%02d", h, m, sec)
    }
}

#Preview {
    // Create a mock InventoryItem for preview
    let mockItem = InventoryItem(
        id: "123",
        itemType: .petItem,
        itemId: ItemDetail(
            id: "456",
            name: "egg5",
            description: "A beautiful egg",
            category: nil,
            isDeleted: false,
            version: 0,
            effectAmount: nil,
            effectType: nil,
            barAffected: nil,
            diamondPrice: nil,
            goldPrice: nil,
            currencyType: nil,
            idAlias: nil
        ),
        acquiredAt: ISO8601DateFormatter().string(from: Date().addingTimeInterval(-3600)),
        properties: ItemProperties(
            egg: ItemProperties.EggProperties(
                crackedAt: ISO8601DateFormatter().string(from: Date().addingTimeInterval(3600)),
                whichEgg: "5",
                eggPackageId: nil,
                whichPetDidItComeFrom: "789",
                isCrackedByUser: false
            ),
            quantity: 1,
            isOwned: true
        )
    )
    
    return HatchEggView(
        item: mockItem,
        onClose: {},
        onHatch: { _ in }
    )
} 