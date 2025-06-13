//
//  SettingsButtonComp.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 5.08.2024.
//

import SwiftUI

struct SettingsButtonComp: View {
    var imageName: String
    var title: String

    var body: some View {
        HStack {
            Image(systemName: "\(imageName)")
                .resizable()
                .frame(width: 30, height: 30)
            Text("\(title)")
                .font(.nunito(.medium, .title320))
                .font(.system(size: 20))
                .padding(.leading, 10)
            Spacer()

        }.frame(width: UIScreen.main.bounds.width * 7.5 / 10, height: 40)
        .padding()
        .padding(.leading, 25)
        .background(Color("settingsbuttoncolor"), in: .rect(cornerRadius: 25))
        .padding(.vertical, 8)
    }
}

#Preview {
    SettingsButtonComp(imageName: "person", title: "Account")
}
