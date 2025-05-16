import Foundation
import Combine

/// Base protocol for all repositories
protocol BaseRepository {
    var networkManager: NetworkManaging { get }
    
    init(networkManager: NetworkManaging)
}

/// Default implementation for base repository initialization
extension BaseRepository {
    init() {
        self.init(networkManager: NetworkManager.shared)
    }
} 