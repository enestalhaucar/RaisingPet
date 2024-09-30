//
//  PetiverseWidgetExtensionBundle.swift
//  PetiverseWidgetExtension
//
//  Created by Enes Talha Uçar  on 30.09.2024.
//

import WidgetKit
import SwiftUI

@main
struct PetiverseWidgetExtensionBundle: WidgetBundle {
    var body: some Widget {
        PetiverseWidgetExtension()
        PetiverseWidgetExtensionLiveActivity()
    }
}
