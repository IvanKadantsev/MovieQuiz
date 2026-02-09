import Foundation

final class StatisticService: StatisticServiceProtocol {

	private let storage: UserDefaults = .standard

	private enum Keys: String {
		case gamesCount          // Для счётчика сыгранных игр
		case bestGameCorrect     // Для количества правильных ответов в лучшей игре
		case bestGameTotal       // Для общего количества вопросов в лучшей игре
		case bestGameDate        // Для даты лучшей игры
		case totalCorrectAnswers // Для общего количества правильных ответов за все игры
		case totalQuestionsAsked // Для общего количества вопросов, заданных за все игры
	}
	
	var gamesCount: Int {
		get {
			storage.integer(forKey: Keys.gamesCount.rawValue)
		}
		set {
			let currentGamesCount = storage.integer(forKey: Keys.gamesCount.rawValue)
			let newGamesCount = currentGamesCount + 1
			storage.set(newGamesCount, forKey: Keys.gamesCount.rawValue)
		}
	}
	
	var bestGame: GameResult {
		get {
			let correct = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
			let total = storage.integer(forKey: Keys.bestGameTotal.rawValue)
			if let date = storage.object(forKey: Keys.bestGameDate.rawValue) as? Date {
				return GameResult(correct: correct, total: total, date: date)
			} else {
				return GameResult(correct: correct, total: total, date: Date())
			}
		}
		set {
			storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
			storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
			storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
		}
	}

	var totalAccuracy: Double {
		let totalCorrect = storage.integer(forKey: Keys.totalCorrectAnswers.rawValue)
		let totalAsked = storage.integer(forKey: Keys.totalQuestionsAsked.rawValue)
			
		guard totalAsked > 0 else {
			return 0.0
		}
			
		return Double(totalCorrect) / Double(totalAsked) * 100
		}

	
	func store(correct count: Int, total amount: Int) {
		let currentCorrect = storage.integer(forKey: Keys.totalCorrectAnswers.rawValue)
		let currentAsced = storage.integer(forKey: Keys.totalQuestionsAsked.rawValue)
		
		storage.set(currentCorrect + count, forKey: Keys.totalCorrectAnswers.rawValue)
		storage.set(currentAsced + amount, forKey: Keys.totalQuestionsAsked.rawValue)
		
		let currentResult = GameResult(correct: count, total: amount, date: Date())
		let bestResult = bestGame
		
		if currentResult.correct > bestResult.correct {
			bestGame = currentResult
		}
		
		let currentGames = storage.integer(forKey: Keys.gamesCount.rawValue)
		storage.set(currentGames + 1, forKey: Keys.gamesCount.rawValue)
	
	}
	
}
