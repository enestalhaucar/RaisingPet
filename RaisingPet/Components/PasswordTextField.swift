//
//  PasswordTextField.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 19.09.2024.
//

import SwiftUI

struct PasswordTextField: View {
    var placeholder: String
    @Binding var text: String
    @State private var isPasswordVisible: Bool = false // Şifre görünürlüğünü kontrol eden değişken
    var body: some View {
        ZStack {
            HStack {
                if isPasswordVisible {
                    // Şifre görünürse normal TextField kullanılır
                    TextField(placeholder, text: $text)
                        .padding()
                        .padding(.leading, 10)

                        .background(Color.white, in: RoundedRectangle(cornerRadius: 25))
                        .foregroundColor(.black)
                } else {
                    // Şifre gizliyse SecureField kullanılır
                    SecureField(placeholder, text: $text)
                        .padding()
                        .padding(.leading, 10)

                        .background(Color.white, in: RoundedRectangle(cornerRadius: 25))
                        .foregroundColor(.black)
                }

                // Göz ikonu ile şifre görünürlüğünü açıp kapama butonu
                Button(action: {
                    isPasswordVisible.toggle() // Şifre görünürlüğünü değiştirme
                }) {
                    Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.gray)
                        .animation(.bouncy, value: isPasswordVisible)
                }
                .frame(width: 44, height: 44, alignment: .center)
                .contentShape(Rectangle())
                .padding(.trailing, 5)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.black, lineWidth: 1)
            }
        }
        .frame(width: ConstantManager.Layout.widthEight)
        .frame(height: 50)
    }
}

#Preview {
    PasswordTextField(placeholder: "Enter Your Password", text: .constant(""))
}
