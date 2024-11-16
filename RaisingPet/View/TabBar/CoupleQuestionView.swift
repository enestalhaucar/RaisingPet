import SwiftUI

struct Question: Identifiable {
    let id = UUID()
    let title: String
    var isFavorite: Bool = false
}

struct CoupleQuestionView: View {
    @State private var questions: [Question] = [
        Question(title: "Relationships and Future Goals"),
        Question(title: "Hobbies and Interests"),
        Question(title: "Emotional Intimacy and Communication"),
        Question(title: "Family and Childhood Memories"),
        Question(title: "Values and Beliefs"),
        Question(title: "Daily Life and Habits"),
        Question(title: "Travel and Adventure"),
        Question(title: "Dreams and Fears"),
        Question(title: "An Ideal Day"),
        Question(title: "Surprises and Romance")
    ]
    

    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    // Eğer favoriler varsa başlık gösterilecek
                    if !favoriteQuestions.isEmpty {
                        HStack {
                            Text("Favorite Questions")
                                .font(.title3)
                                .bold()
                                .padding()
                            Spacer()
                        }.padding(.horizontal)
                    }
                    
                    // Favori sorular
                    ForEach(favoriteQuestions) { question in
                        HStack {
                            Image("trainIcon")
                            Spacer()
                            Text(question.title)
                            Spacer()
                            Image(systemName: question.isFavorite ? "heart.fill" : "heart")
                                .onTapGesture {
                                    toggleFavorite(for: question)
                                }
                        }
                        .padding()
                        .frame(width: UIScreen.main.bounds.width * 8 / 10)
                        .background(Color.blue.opacity(0.4).gradient)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding()
                    }
                    
                    // Eğer sorular varsa başlık gösterilecek
                    if !questions.isEmpty {
                        HStack {
                            Text("Main Questions")
                                .font(.title3)
                                .bold()
                                .padding()
                            Spacer()
                        }.padding(.horizontal)
                    }
                    
                    // Ana sorular
                    ForEach(questions) { question in
                        HStack {
                            Image("trainIcon")
                            Spacer()
                            Text(question.title)
                            Spacer()
                            Image(systemName: question.isFavorite ? "heart.fill" : "heart")
                                .onTapGesture {
                                    toggleFavorite(for: question)
                                }
                        }
                        .padding()
                        .frame(width: UIScreen.main.bounds.width * 8 / 10)
                        .background(Color.blue.opacity(0.4).gradient)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding()
                    }
                    
                    Spacer()
                }
                .navigationTitle("Couple Questions")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink(destination: AddNewQuestionView()) {
                            Image(systemName : "plus")
                        }
                    }
                }
            }
        }
    }
    
    // Filtrelenmiş favori soru listesi
    var favoriteQuestions: [Question] {
        return questions.filter { $0.isFavorite }
    }
    
    // Sorunun favori durumunu değiştiren fonksiyon
    func toggleFavorite(for question: Question) {
        if let index = questions.firstIndex(where: { $0.id == question.id }) {
            questions[index].isFavorite.toggle()
        }
    }
}

#Preview {
    CoupleQuestionView()
}


struct AddNewQuestionView : View {
    var body: some View {
        VStack {
            Text("Hello")
        }
    }
}
