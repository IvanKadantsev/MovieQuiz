//
//  QuizRezultPresenter.swift
//  MovieQuiz
//
//  Created by Татьяна Каданцева on 03.02.2026.
//


class QuizResultPresenter: QuizResultProtocol {
	func updateCorrectAnswer(count: Int) {
		self.correctAnswer = count
	}
	
	private var correctAnswer: Int
	private let questionsAmount: Int
		
	init(correctAnswer: Int, questionsAmount: Int) {
		self.correctAnswer = correctAnswer
		self.questionsAmount = questionsAmount
	}
	
	func makeResultsMessage() -> String {
		let statisticService = StatisticService()
		let text = "Ваш результат: \(correctAnswer)/\(questionsAmount)\n" +
		"Количество сыграных квизов: \(statisticService.gamesCount)\n" +
		"Рекорд: \(statisticService.bestGame.correct)/10 \(statisticService.bestGame.date.dateTimeString)\n" +
		"Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
	
		

		return text
	}

	func restartGame() {
		print("Игра перезапущена")
		correctAnswer = 0
	}

}
//
