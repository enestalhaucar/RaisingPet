//
//  PreviewDesignComponent.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar on 7.03.2025.
//

import SwiftUI

struct PreviewDesignComponent: View {
    var title: String
    var subTitle: String
    var body: some View {
        ZStack {
            VStack {
                VStack(spacing: 4) {
                    HStack {
                        Text(title).font(.nunito(.semiBold, .caption12))
                            .foregroundColor(.black)
                        Spacer()
                    }
                    HStack {
                        Text(subTitle).font(.nunito(.semiBold, .xsmall))
                            .foregroundColor(.gray)
                        Spacer()
                    }
                }.padding(12)

                Spacer()
                HStack {
                    Spacer()
                    GeometryReader { geometry in
                        RoundedRectangle(cornerRadius: 10).frame(width: geometry.size.width / 2, height: 60).foregroundStyle(.green.opacity(0.1))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .frame(height: 60)
                }

            }
        }.frame(height: 120)
        .background(RoundedRectangle(cornerRadius: 10).stroke(style: .init(lineWidth: 1)))
    }
}

#Preview {
    PreviewDesignComponent(title: "Pets", subTitle: "Co-parenting with your pet")
}
