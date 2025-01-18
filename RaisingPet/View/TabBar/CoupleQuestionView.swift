import SwiftUI

struct QuestionType : Identifiable, Hashable {
    let id = UUID()
    let title : String
    let imageName : String
    
}



class CoupleQuestionViewModel : ObservableObject {
    let QuestionTypeList : [QuestionType] = [
        QuestionType(title: "Favorites", imageName: "favoritesQuizIcon"),
        QuestionType(title: "Habits", imageName: "routineQuizIcon"),
        QuestionType(title: "Firsts & Memories", imageName: "memoriesQuizIcon"),
        QuestionType(title: "Dreams & Plans", imageName: "dreamsQuizIcon"),
        QuestionType(title: "Who’s More?", imageName: "whowhoQuizIcon"),
        QuestionType(title: "Details", imageName: "detailsQuizIcon"),
        QuestionType(title: "Personality", imageName: "charachterQuizIcon"),
        QuestionType(title: "Love & Romance", imageName: "loveQuizIcon"),
        QuestionType(title: "Family & Friends", imageName: "familyQuizIcon"),
        QuestionType(title: "Dislikes", imageName: "dislikesQuizIcon"),
    ]
    
    
}


struct CoupleQuestionView: View {
    @StateObject private var viewModel = CoupleQuestionViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("mainbgColor").ignoresSafeArea()
                QuizesView(questionTypeList: viewModel.QuestionTypeList)
            }.navigationTitle("Couple Questions")
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: QuestionType.self) { questionType in
                    QuizQuestionView(title: questionType.title)
                }
        }
    }
}




#Preview {
    CoupleQuestionView()
}

struct QuizesView: View {
    let questionTypeList: [QuestionType]
    var body: some View {
        ScrollView {
            GeometryReader { geometry in
                let screenWidth = geometry.size.width
                
                ZStack {
                    ForEach(0..<questionTypeList.count, id: \.self) { index in
                        
                        let question = questionTypeList[index]
                        // Çemberler
                        let xOffset = index % 2 == 0 ? screenWidth * 0.3 : screenWidth * 0.7
                        let yOffset = CGFloat(index) * 150 + 100
                        
                        
                  
                        
                        
                        // Pati İzleri (Çemberler arasındaki bağlantılar)
                        if index < 9 { // Son çember için bağlantı eklemiyoruz
                            let nextXOffset = (index + 1) % 2 == 0 ? screenWidth * 0.3 : screenWidth * 0.7
                            let nextYOffset = CGFloat(index + 1) * 150 + 100
                            
                            ForEach(0..<7, id: \.self) { step in
                                let progress = CGFloat(step) / 6
                                let pawX = xOffset + (nextXOffset - xOffset) * progress
                                let pawY = yOffset + (nextYOffset - yOffset) * progress
                                
                                Image(systemName: "pawprint.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(.pink)
                                    .position(x: pawX, y: pawY)
                            }
                        }
                        NavigationLink(value: question) {
                            CircleProgressView(imageName: question.imageName)
                        }.position(x: xOffset, y: yOffset)
                    }
                }
            }
            .padding(.vertical, 20)
            .frame(height: 1500)
        }
    }
}




struct CircleProgressView: View {
    var imageName : String
    
    var body: some View {
        ZStack {
            Circle()
                .fill(.gray.opacity(1))
                .frame(width: 100, height: 100)
            
            Image("\(imageName)")
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
            
            Circle()
                .trim(from: 0.0, to: 0.0) // Çözümüne göre değişecek
                .stroke(Color.blue, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .rotationEffect(.degrees(-90))
            
                .frame(width: 100, height: 100)
                .shadow(radius: 10)
        }
    }
}


