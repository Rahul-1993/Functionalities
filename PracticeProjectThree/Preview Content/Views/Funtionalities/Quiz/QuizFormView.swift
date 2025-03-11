//
//  QuizFormView.swift
//  PracticeProjectThree
//
//  Created by Rahul Avale on 1/27/25.
//

import SwiftUI

struct QuizCategory: Identifiable, Hashable {
    let id: Int
    let categoryName: String
}

class QuizFormViewModel: ObservableObject {
    
    var urlString: String = quizBaseUrl
    @Published var quizFormPage: Int = 1
    
    @Published var numberOfQuestions: String = ""
    @Published var selectedCategory: QuizCategory?
    @Published var selectedDifficulty: String = ""
    
    @Published var quizStarted: Bool = false
    
    var allCategories: [QuizCategory] = [
        QuizCategory(id: 9, categoryName: "General Knowledge"),
        QuizCategory(id: 10, categoryName: "Entertainment: Books"),
        QuizCategory(id: 11, categoryName: "Entertainment: Film"),
        QuizCategory(id: 12, categoryName: "Entertainment: Music"),
        QuizCategory(id: 13, categoryName: "Entertainment: Musical & Theatre"),
        QuizCategory(id: 14, categoryName: "Entertainment: Television"),
        QuizCategory(id: 15, categoryName: "Entertainment: Video Games"),
        QuizCategory(id: 16, categoryName: "Entertainment: Board Games"),
        QuizCategory(id: 17, categoryName: "Science & Nature"),
        QuizCategory(id: 18, categoryName: "Science: Computers"),
        QuizCategory(id: 19, categoryName: "Science: Mathematics"),
        QuizCategory(id: 20, categoryName: "Mythology"),
        QuizCategory(id: 21, categoryName: "Sports")
    ]
    
    func handleBottomButton() {
        switch quizFormPage {
            case 1:
            urlString += "amount=\(numberOfQuestions)"
            quizFormPage += 1
        case 2:
            if let category = selectedCategory {
                urlString += "&category=\(category.id)"
            }
            quizFormPage += 1
            
        case 3:
            urlString += "&difficulty=\(selectedDifficulty.lowercased())&type=multiple"
            print(urlString)
            quizStarted.toggle()
        default:
            break
        }
    }
    
    
    
}

struct QuizFormView: View {
    @StateObject private var viewModel = QuizFormViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                RadialGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1))]),
                               center: .topLeading,
                               startRadius: 5,
                               endRadius: UIScreen.main.bounds.height)
                .ignoresSafeArea()
                    VStack {
                        switch viewModel.quizFormPage {
                            
                        case 1:
                            numberOfQuestionsSection
                            
                        case 2:
                            selectCategorySection
                            
                        case 3:
                            selectDifficultySection
                            
                        default:
                            Text("Default")
                        }
                        
                        buttomButtonSection
                    }
                    .navigationDestination(isPresented: $viewModel.quizStarted) {
                        QuizView(urlString: viewModel.urlString)
                    }
            }
        }
    }
}

extension QuizFormView {
    private var selectCategorySection : some View {
        VStack {
            Spacer()
            Text("Select Category")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .padding()
            
            Picker("Select Category", selection: $viewModel.selectedCategory) {
                ForEach(viewModel.allCategories) { category in
                    Text(category.categoryName)
                        .foregroundStyle(.white)
                        .tag(category as QuizCategory)
                }
            }
            .pickerStyle(.wheel)
            .padding(.vertical)
            
            if viewModel.selectedCategory != nil {
                Text(viewModel.selectedCategory?.categoryName ?? "")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
            } else {
                Text("Please select a category")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.gray)
            }
            Spacer()
            Spacer()
        }
    }
    
    private var numberOfQuestionsSection: some View {
        VStack {
            Spacer()
            Text("Number of Questions")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .padding()
            
            TextField("Enter number of questions here", text: $viewModel.numberOfQuestions)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.purple)
                .frame(width: 100, height: 50)
                .background(.white)
                .clipShape(.capsule)
                .keyboardType(.numberPad)
                .padding()
            
            Spacer()
            Spacer()
            
        }
    }
    
    private var selectDifficultySection: some View {
        VStack {
            Spacer()
            Text("Select Difficulty")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .padding()
            
            Picker("Select Difficulty", selection: $viewModel.selectedDifficulty) {
                Text("Easy").tag("Easy")
                Text("Medium").tag("Medium")
                Text("Hard").tag("Hard")
            }
            .pickerStyle(.palette)
            .frame(height: 30)
            .frame(maxWidth: .infinity)
            .background(.gray)
            .clipShape(.capsule)
            .padding()
            
            Text(viewModel.selectedDifficulty.count > 1 ? viewModel.selectedDifficulty : "Your Selection")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
            
            Spacer()
            Spacer()
        }
    }
    
    private var buttomButtonSection: some View {
        VStack {
            Text(viewModel.quizFormPage == 3 ? "Start Quiz" : "Next")
                .font(.title2)
                .fontWeight(.semibold)
                .font(.title2)
                .foregroundStyle(.purple)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background()
                .clipShape(.capsule)
                .padding()
                .onTapGesture {
                    viewModel.handleBottomButton()
                }
        }
    }
}

#Preview {
    QuizFormView()
}
