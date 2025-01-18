//
//  PetCareView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 4.09.2024.
//

import SwiftUI

struct PetCareView: View {
    @State private var deletePetShow : Bool = false
    var body: some View {
        NavigationStack {
            ZStack {
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
                                    NavigationLink(destination: ShopScreenView()) {
                                        VStack {
                                            Image("shopIcon")
                                            Text("Shop")
                                                .foregroundStyle(.black)
                                        }
                                    }
                                    
                                }
                                Spacer()
                                Image("pet")
                                Spacer()
                                VStack {
                                    NavigationLink(destination: LuckyBoxView()) {
                                        VStack {
                                            Image("LuckyDraw")
                                            Text("Lucky Draw")
                                                .foregroundStyle(.black)
                                            
                                        }
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
                    
                }
                if deletePetShow {
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .foregroundStyle(Color.white)
                            .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.blue,lineWidth: 1))
                        
                        VStack(spacing: 10) {
                            Image("deletingBG")
                                .resizable()
                                .scaledToFit()
                                .frame(width: UIScreen.main.bounds.size.width * 0.7, height: UIScreen.main.bounds.size.width * 0.7)
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                                .padding(.vertical,10)
                                .padding(.horizontal,10)
                            
                            Text("Panda’yı ormana bıraktığında sonsuza kadar senden ayrı olucak ve vahşi doğada hayatta kalmaya çalışıcak")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .padding(.horizontal)
                            HStack {
                                Button {
                                    deletePetShow = false
                                } label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundStyle(.red.opacity(0.3))
                                        Text("İptal")
                                    }.padding(.leading)
                                        .frame(height: 40)
                                }
                                Spacer()
                                Button {
                                    // Peti sil
                                } label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundStyle(.blue.opacity(0.3))
                                        Text("Pet'i sil")
                                    }.padding(.trailing)
                                        .frame(height: 40)
                                }
                            }.padding(.bottom,15)
                            
                        }
                        
                    }.frame(width: UIScreen.main.bounds.size.width * 0.8)
                        .frame(maxHeight: UIScreen.main.bounds.size.height * 0.55)
                }
            }.toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button  {
                        deletePetShow = true
                    } label: {
                        Image(systemName: "gear")
                            .foregroundStyle(Color.orange)
                    }
                }
            }
        }
    }
}

#Preview {
    PetCareView()
}
