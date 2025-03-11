//
//  QuizView.swift
//  PracticeProjectThree
//
//  Created by Rahul Avale on 1/24/25.
//

import SwiftUI

struct Quiz: Codable {
    let responseCode: Int
    let results: [Result]

    enum CodingKeys: String, CodingKey {
        case responseCode = "response_code"
        case results
    }
}

// MARK: - Result
struct Result: Codable, Identifiable {
    
    let id: UUID = UUID()
    let type: String
    let difficulty: String
    let category: String
    let question, correctAnswer: String
    let incorrectAnswers: [String]
    let shuffledAnswers: [String]

    enum CodingKeys: String, CodingKey {
        case type, difficulty, category, question
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
        case shuffledAnswers
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(String.self, forKey: .type)
        self.difficulty = try container.decode(String.self, forKey: .difficulty)
        self.category = try container.decode(String.self, forKey: .category)
        self.question = try container.decode(String.self, forKey: .question)
        self.correctAnswer = try container.decode(String.self, forKey: .correctAnswer)
        self.incorrectAnswers = try container.decode([String].self, forKey: .incorrectAnswers)
        self.shuffledAnswers = ([correctAnswer] + incorrectAnswers).shuffled()
    }
}

class QuizDataService {
    
    func fetchQuizUsingGenerics(urlString: String) async throws-> Quiz? {
        let genericsDataService = GenericDataService()
        
        if let url = URL(string: urlString) {
            return await genericsDataService.fetchData(from: url)
            
        }
        
        return nil
    }
    
    func fetchQuiz(urlString: String) async throws -> Quiz? {
        let url = URL(string: urlString)!
        
        let (data, response) = try await URLSession.shared.data(from: url)
        let returnedQuiz = handleResponse(data: data, response: response)
        return returnedQuiz

    }
    
    func handleResponse(data: Data?, response: URLResponse?) -> Quiz? {
        guard
            let data = data,
            let response = response as? HTTPURLResponse
            else {
            print("initial check failed")
            return nil
        }
        
        do {
            let returnedData = try JSONDecoder().decode(Quiz.self, from: data)
            print("Decoding successful")
            return returnedData
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
        
        
    }
    
}

class QuizViewModel: ObservableObject {
    @Published var quiz: Quiz?
    @Published var answerArrayNew: [String] = []
    @Published var currentQuestionIndex = 0
    @Published var selectedAnswer: String?
    
    var correctAnswersCount: Int = 0
    
    let urlString: String
    let dataService = QuizDataService()
    
    init(urlString: String) {
        self.urlString = urlString
        print(urlString)
        Task {
            await loadQuiz()
        }
    }
    
    func loadQuiz() async {
//        do {
//            let fetchedQuiz = try await dataService.fetchQuiz(urlString: urlString)
//            await MainActor.run {
//                self.quiz = fetchedQuiz
//            }
//        
//        } catch  {
//            print("Error fetching quiz: \(error)")
//        }
        do {
            let fetchedData = try await dataService.fetchQuizUsingGenerics(urlString: urlString)
            await MainActor.run {
                self.quiz = fetchedData
            }
        } catch {
            print("Error fetching data: \(error)")
        }
        
        
    }
    
    func nextQuestion() {
        if let quiz = quiz, currentQuestionIndex < quiz.results.count {
            withAnimation {
                currentQuestionIndex += 1
                selectedAnswer = nil
            }
        }
    }
    
    func checkAnswer(selectedAnswer: String, correctAnswer: String) -> Color {
        if selectedAnswer == correctAnswer {
            correctAnswersCount += 1
            return Color.green.opacity(0.5)
        } else {
            return Color.red.opacity(0.8)
        }
    }
    
}

struct QuizView: View {
    @StateObject private var viewModel: QuizViewModel
    @State private var selectedOption: String?
    
    let transitionScreen: AnyTransition = .asymmetric(
        insertion: .move(edge: .trailing),
        removal: .move(edge: .leading))
    
    
    init(urlString: String) {
        _viewModel = StateObject(wrappedValue: QuizViewModel(urlString: urlString))
    }
    
    var body: some View {
        @Environment(\.dismiss) var dismiss
        ZStack {
            
            RadialGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1))]), center: .topLeading, startRadius: 5, endRadius: UIScreen.main.bounds.height)
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                if let quiz = viewModel.quiz, quiz.results.indices.contains(viewModel.currentQuestionIndex) {
                    let question = quiz.results[viewModel.currentQuestionIndex]
                    
                    GroupBox {
                        Text(question.question.decodedHTMLEntities())
                            .font(.title2)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(
                                viewModel.selectedAnswer != nil ? viewModel.checkAnswer(selectedAnswer: viewModel.selectedAnswer ?? "", correctAnswer: question.correctAnswer) : Color.purple.opacity(0.2)
                            )
                            .clipShape(.capsule)
                    }

                    GroupBox {
                        VStack(spacing: 20) {
                            ForEach(question.shuffledAnswers, id: \.self) { answer in
                                Text(answer)
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(answer == viewModel.selectedAnswer ? Color.purple.opacity(0.8) : Color.purple.opacity(0.2))
                                    .clipShape(.capsule)
                                    .onTapGesture {
                                        if viewModel.selectedAnswer == nil {
                                            viewModel.selectedAnswer = answer
                                            print("Answer Selected: \(answer) Actual Answer: \(question.correctAnswer)")
                                        }
                                    }
                                }
                        }
                        .padding()
                        .gesture(
                            DragGesture()
                                .onEnded({ value in
                                    if value.translation.width < -50 {
                                        viewModel.nextQuestion()
                                    }
                                })
                        )
                        .transition(transitionScreen)
                    }
                    
                    
                    Button(action: viewModel.nextQuestion) {
                        Text("Next")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.purple)
                            .clipShape(.capsule)
                    }
                    .padding(.horizontal)
                    .disabled(
                        viewModel.selectedAnswer == nil ? true : false
                    )
                } else {
                    VStack {
                        Text("Quiz Completed!")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                        Text("\(viewModel.correctAnswersCount) out of \(viewModel.quiz?.results.count ?? 0)")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                        Text("You're an idiot Vidhi")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                    }
                    
                }
            }
            .padding()
        }

    }
}

#Preview {
    QuizView(urlString: "https://opentdb.com/api.php?amount=10&category=9&difficulty=easy&type=multiple")
}
