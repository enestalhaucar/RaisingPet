//
//  PetiverseWidgetBundle.swift
//  PetiverseWidget
//
//  Created by Enes Talha Uçar on 13.04.2025.
//

import WidgetKit
import SwiftUI

@main
struct PetiverseWidgetBundle: WidgetBundle {
    var body: some Widget {
        PetiverseWidget()
        PetiverseWidgetControl()
        PetiverseWidgetLiveActivity()
    }
}
