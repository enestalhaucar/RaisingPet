//
//  GetPetsResponseModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 15.05.2025.
//

import Foundation

// MARK: - Get Pets Response Model
struct GetPetsResponseModel: Codable {
    let status: String
    let data: PetsData
}

// MARK: - Pets Data Wrapper
struct PetsData: Codable {
    let pets: [Pet]
}
