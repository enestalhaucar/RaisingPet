//
//  PetCareView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 4.09.2024.
//

import SwiftUI

struct PetCareView: View {
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    Image("petCareViewBg")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height / 2)
                    
                    VStack(spacing: 50) {
                        VStack {
                            
                        }.frame(width: 100, height: 50)
                        
                        HStack {
                            VStack {
                                VStack {
                                    Image("historyIcon")
                                    Text("History")
                                        .foregroundStyle(.black)
                                    
                                }
                                VStack {
                                    Image("shopIcon")
                                    Text("Shop")
                                        .foregroundStyle(.black)
                                }
                            }
                            Spacer()
                            Image("pet")
                            Spacer()
                            VStack {
                                VStack {
                                    Image("PlayGameIcon")
                                    Text("Play Game")
                                        .foregroundStyle(.black)
                                    
                                }
                                VStack {
                                    Image("DormIcon")
                                    Text("Dorm")
                                        .foregroundStyle(.black)
                                }
                            }
                            
                        }.padding(.horizontal)
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(width: 44, height: 44)
                                    .foregroundStyle(.yellow)
                                Image("smileyIcon")
                            }
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(width: 44, height: 44)
                                    .foregroundStyle(.yellow)
                                Image("foodIcon")
                            }
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(width: 44, height: 44)
                                    .foregroundStyle(.yellow)
                                Image("waterIcon")
                            }
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(width: 44, height: 44)
                                    .foregroundStyle(.yellow)
                                Image("bathIcon")
                            }
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(width: 44, height: 44)
                                    .foregroundStyle(.yellow)
                                Image("toiletIcon")
                            }
                        }.padding(.top)
                    }
                    
                }.ignoresSafeArea(.all)
                
                VStack {
                    HStack {
                        Text("Drinks")
                        Spacer()
                    }.padding(.horizontal,40)
                    
                    HStack(spacing: 40) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 82, height: 82)
                                .foregroundStyle(Color("EggBackgroundColor"))
                            Image("mojito")
                        }
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 82, height: 82)
                                .foregroundStyle(Color("EggBackgroundColor"))
                            Image("mojito")
                        }
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 82, height: 82)
                                .foregroundStyle(Color("EggBackgroundColor"))
                            Image("mojito")
                        }
                    }
                    HStack(spacing: 40) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 82, height: 82)
                                .foregroundStyle(Color("EggBackgroundColor"))
                            Image("mojito")
                        }
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 82, height: 82)
                                .foregroundStyle(Color("EggBackgroundColor"))
                            Image("mojito")
                        }
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 82, height: 82)
                                .foregroundStyle(Color("EggBackgroundColor"))
                            Image("mojito")
                        }
                    }
                    Spacer()
                }.offset(y: -65)
                
            }.toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: "gear")
                        .foregroundStyle(Color.orange)
                }
            }
        }
    }
}

#Preview {
    PetCareView()
}
