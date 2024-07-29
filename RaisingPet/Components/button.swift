//
//  button.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 29.07.2024.
//

import SwiftUI

struct button: View {
    var title : String
    var body: some View {
        Text("Get Started")
            .foregroundStyle(.white)
            .frame(width: 350, height: 50)
            .background(Color("buttonBackgroundColor"), in: .rect(cornerRadius: 25))
    }
}

#Preview {
    button(title: "Get Started")
}
