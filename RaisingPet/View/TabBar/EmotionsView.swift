//
//  EmotionsView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 26.08.2024.
//

import SwiftUI

struct EmotionsView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color("mainbgColor").ignoresSafeArea()
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .frame(width: 264, height: 229)
                            .foregroundStyle(Color("EggBackgroundColor"))
                        VStack {
                            Text("😘")
                                .font(.system(size: 65))
                            Text("Öpücük Göndermek için iki parmağınla dokun")
                                .frame(maxWidth: 220)
                                .multilineTextAlignment(.center)
                        }
                    }.padding(.vertical)

                    Button {

                    } label: {
                        Text("Unlock & Specialize Action")
                            .foregroundStyle(.white)
                            .padding(25)
                            .background(Color("friendsViewbuttonColor") )
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                    }.padding(.vertical)

                    HStack {
                        VStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundStyle(Color("EggBackgroundColor"))
                                    .frame(width: 90, height: 90)
                                Text("😘")
                                    .font(.system(size: 45))
                            }
                            Text("Kiss")
                                .font(.title3)

                        }

                        VStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundStyle(Color("EggBackgroundColor"))
                                    .frame(width: 90, height: 90)
                                Text("🤏🏻")
                                    .font(.system(size: 45))
                            }
                            Text("Pinch")
                                .font(.title3)

                        }
                        VStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundStyle(Color("EggBackgroundColor"))
                                    .frame(width: 90, height: 90)
                                Text("🤗")
                                    .font(.system(size: 45))
                            }
                            Text("Hug")
                                .font(.title3)

                        }
                    }

                    Spacer()

                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .foregroundColor(Color("friendsViewbuttonColor"))
                            .frame(height: 100)
                            .padding(.horizontal)
                        HStack(spacing: 10) {
                            VStack {
                                Circle().frame(width: 64, height: 64)
                                    .foregroundStyle(.white)
                            }
                            Text("Friend's Name")
                            Spacer()
                            Button(action: {

                            }, label: {
                                Text("Select")
                                    .foregroundStyle(.white)
                            })
                        }.padding(.horizontal)
                            .padding()
                    }

                }.navigationTitle("Emotions")
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

#Preview {
    EmotionsView()
}
