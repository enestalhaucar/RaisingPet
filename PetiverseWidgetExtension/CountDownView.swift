//
//  CountDownView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 9.10.2024.
//

import SwiftUI

struct CountDownView: View {
    var title : String
    var dayText : Int
    var hourText : Int
    var minuteText : Int
    var backgroundImage : Image
    var backgroundImageSelected : Bool
    var body: some View {
        ZStack {
            if backgroundImageSelected {
                Image("\(backgroundImage)")
            } else {
                Color.green.opacity(0.5)
            }
            
            VStack(alignment: .leading, content: {
                HStack(alignment: .bottom) {
                    Text("\(title)").padding(.top, 20).padding(.leading,20)
                        .font(.title3)
                        .fontWeight(.heavy)
                    Spacer()
                    
                    
                }.frame(alignment: .leading)
                Spacer()
                VStack(alignment: .leading) {
                    Text("\(dayText) Days").font(.title).bold()
                    Text("\(hourText) Hour").bold()
                    Text("\(minuteText) Minutes").bold()
                }.padding(.bottom, 10)
                    .padding(.leading)
            }).foregroundStyle(.white)

            
            
        }.frame(width: 350, height: 170)
            
    }
}

#Preview {
    CountDownView(title: "Maldives", dayText: 24, hourText: 8, minuteText: 43, backgroundImage: Image("notesIcon"), backgroundImageSelected: false)
}

