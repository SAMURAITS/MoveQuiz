import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - Lifecycle
    
    @IBOutlet private var imageView: UIImageView!
    
    @IBOutlet private var textLabel: UILabel!
    
    @IBOutlet private var counterLabel: UILabel!
    
    @IBOutlet private weak var questionLabel: UILabel!
    
    @IBOutlet private weak var noButton: UIButton!
    
    @IBOutlet private weak var yesButton: UIButton!
    
    
    //Переменная с индексом текущего вопроса
    private var currentQuestionIndex = 0
    
    //Переменная счетчика вопросов
    private var correctAnswer = 0
    
    private var questionFactory: QuestionFactoryProtocol?
    
    private let questionsAmount: Int = 10
    
    private var currentQuestion: QuizQuestion?
    
    private var alertPresenter = AlertPresenter()
    
    private var statisticsService: StatisticServiceProtocol = StatisticService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statisticsService = StatisticService()
        
       let questionFactory = QuestionFactory()
        questionFactory.delegate = self
        self.questionFactory = questionFactory

        
        setupFont()
        
        imageView.layer.cornerRadius = 20
    
        questionFactory.requestNextQuestion()
    }
    
    // MARK: - QuestionFactoryDelegate

    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
               return
           }

           currentQuestion = question
           let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
               self?.show(quiz: viewModel)
           }
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    private func show (quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        
        if givenAnswer == currentQuestion.correctAnswer {
            correctAnswer += 1
            
        }
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
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
        if currentQuestionIndex >= questionsAmount - 1 {
            // идём в состояние "Результат квиза"
            statisticsService.store(correct: correctAnswer, total: questionsAmount)

            let gamesCount = statisticsService.gamesCount
            let bestGame = statisticsService.bestGame
            
            let text = "Ваш результат: \(correctAnswer)/\(questionsAmount)\n" +
            "Количество сыграных квизов: \(gamesCount)\n" +
            "Рекорд: \(bestGame.correct)/\(bestGame.total) \(statisticsService.bestGame.date.dateTimeString)\n" +
            "Средняя точность: \(String(format: "%.2f", statisticsService.totalAccuracy))%"
            let finalNewModel = QuizResultsViewModel(title: "Этот раунд окончен!", text: text, buttonText: "Сыграть ещё раз")

            showResultAlert(finalNewModel)
        } else {

            currentQuestionIndex += 1
            
            questionFactory?.requestNextQuestion()
            
            imageView.layer.borderWidth = 0
        }
        
    }
    private func showResultAlert(_ result: QuizResultsViewModel) {
        
        let alert = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText,
            completion: {[weak self] in
                self?.resetGame()
                
            } )
        alertPresenter.showResult(viewcontroller: self, model: alert)
    }
        private func resetGame() {
            currentQuestionIndex = 0
            correctAnswer = 0
            questionFactory?.requestNextQuestion()
            imageView.layer.borderWidth = 0
                
            }
        
             
     
    private func setupFont(){
        questionLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        counterLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        textLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        noButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        yesButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
    }
    
}
            
        

  
    
 

    
    
    

