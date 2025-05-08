//
//  HatchPetsResponseModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 7.05.2025.
//

// HatchPetsResponse.swift

import Foundation

struct HatchPetsResponse: Codable {
    let status: String
    let data: HatchPetsData
    let message: String?
}

// MARK: - Hatch Pets Data Wrapper
struct HatchPetsData: Codable {
    let pets: [Pet]
}
