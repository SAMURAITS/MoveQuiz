import UIKit

struct ViewModel {
    let image: UIImage
    let question: String
    let questionNumber: String
}

// для состояния "Вопрос показан"
struct QuizStepViewModel {
  let image: UIImage
  let question: String
  let questionNumber: String
}

// для состояния "Результат квиза"
struct QuizResultsViewModel {
  let title: String
  let text: String
  let buttonText: String
}

struct QuizQuestion {
    let image: String
    let text: String
    let correctAnswer: Bool
}


final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    
    private let questions: [QuizQuestion] = [
        QuizQuestion(
            image: "The Godfather",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Dark Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Kill Bill",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Avengers",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Deadpool",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Old",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Tesla",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false)
    ]
    
    //Переменная с индексом текущего вопроса
    private var currentQuestionIndex = 0
    
    //Переменная счетчика вопросов
    private var correctAnswer = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for family in UIFont.familyNames {
                    print("family:", family)
                    for font in UIFont.fontNames(forFamilyName: family) {
                        print("font:", font)
                    }
                }
        imageView.layer.cornerRadius = 20
        let currentQuestion = questions[currentQuestionIndex]
        show(quiz: convert(model: currentQuestion))
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
        return questionStep
    }
    
    private func show (quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
    }
    
    
    @IBAction func yesButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = true
        
        if givenAnswer == currentQuestion.correctAnswer {
            correctAnswer += 1
            
        }
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction func noButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = false
        
        if givenAnswer == currentQuestion.correctAnswer {
            correctAnswer += 1
            
        }
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    private func showAnswerResult(isCorrect: Bool){
        imageView.layer.borderWidth = 8
        if isCorrect {
            imageView.layer.borderColor = UIColor(resource: .ypGreen).cgColor
        } else {
            imageView.layer.borderColor = UIColor(resource: .ypRed).cgColor
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            // идём в состояние "Результат квиза"
            let text = "Ваш результат: \(correctAnswer)/10"
            let finalNewModel = QuizResultsViewModel(
                        title: "Этот раунд окончен!",
                        text: text,
                        buttonText: "Сыграть ещё раз")
            showResultAlert(finalNewModel)
        } else {
            currentQuestionIndex += 1
            imageView.layer.borderWidth = 0
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            
            show(quiz: viewModel)
            // идём в состояние "Вопрос показан"
            
        }
        
        
    }
    private func showResultAlert(_ result: QuizResultsViewModel) {
        
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            // сбрасываем переменную с количеством правильных ответов
            self.correctAnswer = 0
            
            self.imageView.layer.borderColor = UIColor.clear.cgColor
            
            // заново показываем первый вопрос
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
 }

    
    
    

