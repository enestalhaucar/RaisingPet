//
//  SignInUpBackground.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 29.07.2024.
//

import SwiftUI

struct SignInUpBackground: View {
    var body: some View {
        Color("backgroundColor").ignoresSafeArea()
        
        Image("shapeEclipse")
            .offset(x: -UIScreen.main.bounds.width / 2 + 70, y: -UIScreen.main.bounds.height / 2 + 50)
    }
}

#Preview {
    SignInUpBackground()
}
