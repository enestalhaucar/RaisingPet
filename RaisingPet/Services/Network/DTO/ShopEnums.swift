import Foundation

// MARK: - Shop-related Enums and Structs

/// Currency type for purchases
enum MineEnum: String, Codable {
    case diamond
    case gold
}

/// Types of packages that can be purchased
enum PackageType: String, Codable {
    case eggPackage
    case petPackage
    case petItemPackage
}

/// Structure for pet item with amount
struct PetItemWithAmount: Codable {
    let petItemId: String
    let amount: Int
} 