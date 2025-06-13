//
//  TextField.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 29.07.2024.
//

import SwiftUI

struct MailTextField: View {
    var placeholder: String
    @Binding var text: String

    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .padding(.leading, 10)
            .frame(width: ConstantManager.Layout.widthEight, height: 50)
            .background(Color.white, in: .rect(cornerRadius: 25))
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .foregroundStyle(.black)

            .overlay {
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.black, lineWidth: 1)
            }

    }
}

#Preview {
    MailTextField(placeholder: "Enter Your name", text: .constant(""))
}
