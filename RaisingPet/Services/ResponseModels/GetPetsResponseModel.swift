//
//  GetPetsResponseModel.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 7.05.2025.
//

import Foundation

// MARK: - Top-Level Response
struct GetPetsResponse: Codable {
    let status: String
    let data: PetsData
}

// MARK: - Pets Data Wrapper
struct PetsData: Codable {
    let pets: [Pet]
}
