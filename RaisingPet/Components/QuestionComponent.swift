//
//  QuestionComponent.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 21.09.2024.
//

import SwiftUI

struct QuestionComponents: View {
    var firstIconName = ""
    var text = ""
    var lastIconName = ""
    var body: some View {
        HStack {
            Image(firstIconName)
            Spacer()
            Text(text)
            Spacer()
            Image(systemName: lastIconName)
        }.padding()
            .frame(width: UIScreen.main.bounds.width * 8 / 10)
            .background(Color.blue.opacity(0.4).gradient)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .padding()
            
    }
}

#Preview {
    QuestionComponents()
}
