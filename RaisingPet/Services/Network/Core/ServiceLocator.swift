import Foundation

/// Service locator pattern for dependency injection
class ServiceLocator {
    static let shared = ServiceLocator()
    
    private var services: [String: Any] = [:]
    
    private init() {
        // Register default network manager
        register(NetworkManager.shared as NetworkManaging)
        
        // Register repositories with default implementations
        register(AuthRepositoryImpl(networkManager: NetworkManager.shared) as AuthRepository)
        register(PetRepositoryImpl(networkManager: NetworkManager.shared) as PetRepository)
        register(ShopRepositoryImpl(networkManager: NetworkManager.shared) as ShopRepository)
        register(QuizRepositoryImpl(networkManager: NetworkManager.shared) as QuizRepository)
        register(InventoryRepositoryImpl(networkManager: NetworkManager.shared) as InventoryRepository)
        register(FriendsRepositoryImpl(networkManager: NetworkManager.shared) as FriendsRepository)
        register(UserProfileRepositoryImpl(networkManager: NetworkManager.shared) as UserProfileRepository)
    }
    
    /// Register a service with its type
    func register<T>(_ service: T) {
        let key = String(describing: T.self)
        services[key] = service
    }
    
    /// Get a service by its type
    func resolve<T>() -> T? {
        let key = String(describing: T.self)
        return services[key] as? T
    }
    
    /// Get a service by its type, or create it if it doesn't exist
    func resolve<T>(_ creator: () -> T) -> T {
        if let service: T = resolve() {
            return service
        }
        
        let service = creator()
        register(service)
        return service
    }
} 