//
//  LuckyBoxView.swift
//  RaisingPet
//
//  Created by Enes Talha Uçar  on 1.11.2024.
//

import SwiftUI

struct LuckyBoxView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Image("luckyDrawBackground")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack(spacing: 25) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 25.0)
                            .foregroundStyle(.white.opacity(0.7))
                            
                        
                        GiftBoxView()
                        
                    }.frame(width: 320, height: 320)
                        .padding(.top, 30)
                    
                    DRAWButtonView()
                    
                    DailyTaskView()
                        
                    
                    
                    
                    
                    Spacer()
                }.navigationTitle("Lucky Draw")
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

#Preview {
    LuckyBoxView()
}

struct GiftBoxView: View {
    var body: some View {
        Grid(alignment: .center, horizontalSpacing: 50, verticalSpacing: 30) {
            GridRow {
                ForEach(0..<3) {_ in
                    VStack(spacing: 10) {
                        Button {
                            
                        } label: {
                            VStack {
                                Image("giftBox")
                                    .frame(width: 50, height: 50)
                                Text("Prize")
                            }
                        }
                        
                    }.padding(.top)
                }
            }
            GridRow {
                ForEach(0..<3) {_ in
                    VStack(spacing: 10) {
                        Button {
                            
                        } label: {
                            VStack {
                                Image("giftBox")
                                    .frame(width: 50, height: 50)
                                Text("Prize")
                            }
                        }
                    }
                }
            }
            GridRow {
                ForEach(0..<3) {_ in
                    VStack(spacing: 10) {
                        Button {
                            
                        } label: {
                            VStack {
                                Image("giftBox")
                                    .frame(width: 50, height: 50)
                                Text("Prize")
                            }
                        }
                    }
                }
            }
            
        }.padding(20)
    }
}

struct DRAWButtonView: View {
    var body: some View {
        Button {
            
        } label: {
            ZStack {
                Circle()
                    .fill(.white.opacity(0.7))
                    .frame(width: 75 ,height: 75)
                
                Text("DRAW!")
            }
        }
    }
}

struct DailyTaskView: View {
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .foregroundStyle(.white.opacity(0.7))
                VStack(spacing: 20) {
                    HStack {
                        Text("Tasks").bold().font(.title2)
                        Spacer()
                        Text("Renewal Period : 24Hr").font(.caption)
                    }.padding()
                    
                    VStack(spacing: 10) {
                        HStack {
                            Text("Task 1")
                            Spacer()
                            Text("Completed").font(.caption2)
                                .padding(.vertical,5)
                                .padding(.horizontal)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 25.0)
                                        .stroke(.gray, lineWidth: 1)
                                }
                            
                        }.padding(.horizontal)
                        HStack {
                            Text("Task 2")
                            Spacer()
                            Text("Completed").font(.caption2)
                                .padding(.vertical,5)
                                .padding(.horizontal)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 25.0)
                                        .stroke(.gray, lineWidth: 1)
                                }
                            
                        }.padding(.horizontal)
                        HStack {
                            Text("Task 3")
                            Spacer()
                            Text("Completed").font(.caption2)
                                .padding(.vertical,5)
                                .padding(.horizontal)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 25.0)
                                        .stroke(.gray, lineWidth: 1)
                                }
                            
                        }.padding(.horizontal)
                    }
                    Spacer()
                }
            }.frame(width: 320)
        }
    }
}
