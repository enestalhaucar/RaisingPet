//
//  TextField.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 29.07.2024.
//

import SwiftUI

struct CustomTextField: View {
    var placeholder : String
    @Binding var text : String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .padding(.leading,10)
            .frame(width: 300, height: 50)
            .background(Color.white, in: .rect(cornerRadius: 25))
            .foregroundStyle(.black)
            
            .overlay {
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.black,lineWidth: 1)
            }
            
        
        
    }
}

#Preview {
    CustomTextField(placeholder: "Enter Your name", text: .constant(""))
}
