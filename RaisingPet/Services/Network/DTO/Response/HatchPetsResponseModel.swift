//
//  HatchPetsResponseModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 15.05.2025.
//

import Foundation

struct HatchPetsResponseModel: Codable {
    let status: String
    let data: HatchPetsData
    let message: String?
}

// MARK: - Hatch Pets Data Wrapper
struct HatchPetsData: Codable {
    let pets: [Pet]
}
