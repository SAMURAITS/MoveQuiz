import Foundation

final class StatisticService {
    private let storage: UserDefaults = .standard
    private enum Keys: String {
        case correct
        case bestGame
        case gamesCount
        case date
        case total
        case correctAnswer
        case totalQuestion
        
    }
}

// или реализуем протокол с помощью расширения
extension StatisticService: StatisticServiceProtocol {

    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
            
        }
        set{
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            let total = storage.integer(forKey: Keys.total.rawValue)
            let correct = storage.integer(forKey: Keys.correct.rawValue)
            let date = storage.object(forKey: Keys.date.rawValue) as? Date ?? Date()
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            storage.set(newValue.correct, forKey: Keys.correct.rawValue)
            storage.set(newValue.total, forKey: Keys.total.rawValue)
            storage.set(newValue.date, forKey: Keys.date.rawValue)
        }
    }
    
    
    var totalCorrectAnswers: Int {
        get {
            storage.integer(forKey: Keys.correctAnswer.rawValue)
        }
        set{
            storage.set(newValue, forKey: Keys.correctAnswer.rawValue)
        }
    }
    
    var totalQuestions: Int {
        get {
            storage.integer(forKey: Keys.totalQuestion.rawValue)
        }
        set{
            storage.set(newValue, forKey: Keys.totalQuestion.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        get {
            let correct = storage.integer(forKey: Keys.correctAnswer.rawValue)
            let total = storage.integer(forKey: Keys.totalQuestion.rawValue)
            guard total > 0 else { return 0.0 }
            return Double(correct) / Double(total) * 100 //избежание деления на ноль
        }
    }
//        var totalCorrectAnswers: Int = 0 // общее количество правильных ответов
//        var totalQuestions: Int = 10     // общее количество вопросов
//
//        // Вычисляемая переменная для средней точности
//        var totalAccuracy: Double {
//            // Проверяем, что количество вопросов не равно нулю, чтобы избежать деления на ноль
//            guard totalQuestions > 0 else { return 0.0 }
//            return Double(totalCorrectAnswers) / Double(totalQuestions)
//        }

    
    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        let correctAnswe = storage.integer(forKey: Keys.correctAnswer.rawValue)
        storage.set(correctAnswe + count, forKey: Keys.correctAnswer.rawValue)
        
        let totalQuestion = storage.integer(forKey: Keys.totalQuestion.rawValue)
        storage.set(totalQuestion + amount, forKey: Keys.totalQuestion.rawValue)
        
        let gameRasult = GameResult(correct: count, total: amount, date: Date())
        
        guard !gameRasult.isBetterThan(bestGame) else {
            bestGame = gameRasult
            return
        }
        
    }
    
     
}


