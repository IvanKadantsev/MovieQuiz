//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//Протокол "получил ли следующий вопрос"

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
	func didReceiveNextQuestion(question: QuizQuestion?)
}

