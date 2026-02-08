//
//  AlertPresenter.swift
//  MovieQuiz
import UIKit
//
final class AlertPresenter {
	func show(in vc: UIViewController, model: AlertModel) {

		let alert = UIAlertController(
			title: model.title,
			message: model.message,
			preferredStyle: UIAlertController.Style.alert)
//		let paragraphStyle = NSMutableParagraphStyle()
//		paragraphStyle.alignment = .center


		
		let action = UIAlertAction(title: model.buttonText, style: .default) { _ in model.completion()
		}
		
		alert.addAction(action)
		vc.present(alert, animated: true, completion: nil)
	}
}

protocol QuizResultProtocol {
	func makeResultsMessage() -> String
	func restartGame()
	func updateCorrectAnswer(count: Int)
}


