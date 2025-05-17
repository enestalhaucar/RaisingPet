import Foundation

/// Helper class to easily access repositories from ViewModels
class RepositoryProvider {
    static let shared = RepositoryProvider()
    
    private let serviceLocator = ServiceLocator.shared
    
    private init() {}
    
    // Authentication
    var authRepository: AuthRepository {
        return serviceLocator.resolve { AuthRepositoryImpl() }
    }
    
    // Pet management
    var petRepository: PetRepository {
        return serviceLocator.resolve { PetRepositoryImpl() }
    }
    
    // Shop
    var shopRepository: ShopRepository {
        return serviceLocator.resolve { ShopRepositoryImpl() }
    }
    
    // Quiz
    var quizRepository: QuizRepository {
        return serviceLocator.resolve { QuizRepositoryImpl() }
    }
    
    // Inventory
    var inventoryRepository: InventoryRepository {
        return serviceLocator.resolve { InventoryRepositoryImpl() }
    }
    
    // Friends
    var friendsRepository: FriendsRepository {
        return serviceLocator.resolve { FriendsRepositoryImpl() }
    }
    
    // User Profile
    var userProfileRepository: UserProfileRepository {
        return serviceLocator.resolve { UserProfileRepositoryImpl() }
    }
} 