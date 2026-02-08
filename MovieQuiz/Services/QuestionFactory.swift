//
//  QuestionFactory.swift
//  MovieQuiz
//
//
//

import Foundation


class QuestionFactory: QuestionFactoryProtocol {

	private var allQuestions: [QuizQuestion] = [
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
			correctAnswer: false),
	]
	private var remainingQuestions: [QuizQuestion] = []
	
	weak var delegate: QuestionFactoryDelegate?
	
	func setup(delegate: QuestionFactoryDelegate) {
		self.delegate = delegate
	}
	func reset() {
		remainingQuestions = []
	}
	func requestNextQuestion() {
		if remainingQuestions.isEmpty {
			 remainingQuestions = allQuestions.shuffled()
		 }
		 guard let nextQuestion = remainingQuestions.first else {
			 delegate?.didReceiveNextQuestion(question: nil)
			 return
		 }
		 remainingQuestions.removeFirst()
		 delegate?.didReceiveNextQuestion(question: nextQuestion)
	}

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
			correctAnswer: false),
	]
}
