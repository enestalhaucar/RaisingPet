import SwiftUI

struct CoupleQuestionView : View {
    @StateObject private var viewModel = CoupleQuestionViewModel()
    @State private var selectedTab: Tab = .harmony
    @State private var selectedIcon : Int = 0
    @State private var sentQuizId : String = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                HStack(spacing: 20) {
                    CoupleQuestionHeaderBarIcon(imageName: "harmonyIcon", text: "Harmony", color: .blue.opacity(0.2), isSelected: selectedIcon == 0)
                        .onTapGesture {
                            selectedIcon = 0
                        }
                    CoupleQuestionHeaderBarIcon(imageName: "aiTerapistIcon", text: "AI Terapist", color: .red.opacity(0.05), isSelected: selectedIcon == 1)
                        .onTapGesture {
                            selectedIcon = 1
                        }
                }.frame(height: 75)
                    .background(Color.white)
                
                Rectangle()
                    .frame(width: Utilities.Constants.width, height: 6)
                    .foregroundStyle(.gray.opacity(0.2))
                
                if selectedTab == .harmony {
                    if viewModel.isLoading {
                        LoadingAnimationView()
                    } else if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    } else if viewModel.quiz.isEmpty {
                        Text("Veri Bulunamadı")
                    } else {
                        ScrollView {
                            VStack(spacing: 15) {
                                ForEach(viewModel.quiz.sorted(by: { ($0.title ?? "-") < ($1.title ?? "-") }), id: \.id) { quiz in
                                    QuizRowView(quiz: quiz)
                                }
                            }
                        }.scrollIndicators(.hidden)
                    }
                } else {
                    AITherapistView()
                }
                Spacer()
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .background(Color(.systemBackground))
        }.onAppear {
            viewModel.fetchQuizzes()
        }
    }
}

#Preview {
    CoupleQuestionView()
}

struct QuizRowView : View {
    let quiz : QuizModel
    var body: some View {
        NavigationLink(destination: QuestionView(quizId: quiz.id ?? "-")) {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .frame(height: 56)
                    .foregroundStyle(.blue.opacity(0.09))
                
                HStack(spacing: 25) {
                    // Icon
                    Image("harmonyIcon")
                        .resizable()
                        .frame(width: 30,height: 30)
                    
                    Text(quiz.title ?? "-")
                        .font(.nunito(.light, .caption12))
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                    if quiz.quizStatus == .continued {
                        Image(systemName: "checkmark")
                    }
                }.padding(.horizontal, 20)
            }.frame(width: Utilities.Constants.widthWithoutEdge, alignment: .leading)
        }
    }
}


enum Tab {
    case harmony, aiTherapist
}

struct CoupleQuestionHeaderBarIcon: View {
    var imageName : String
    var text : String
    var color : Color
    var isSelected : Bool
    var body: some View {
        HStack(spacing: 10) {
            Image(imageName)
                .resizable()
                .frame(width: 30, height: 30)
            Text(text)
        }
        .padding()
        .background(color)
        .background(in: RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
        )
    }
}
struct AITherapistView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "wrench.and.screwdriver")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundStyle(.gray.opacity(0.4))
            VStack(spacing: 8) {
                Text("AI Terapist Geliştiriliyor")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                
                Text("Şu anda AI Terapist özelliğimizi en iyi hale getirmek için çalışıyoruz. Çok yakında size yapay zeka destekli rehberlik sunacağız. Lütfen bizi takip etmeye devam edin!")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 24)
        }
        .padding()
    }
}


