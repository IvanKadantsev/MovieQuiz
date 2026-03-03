import UIKit

protocol QuizResultProtocol {
	func makeResultsMessage() -> String
	func restartGame()
	func updateCorrectAnswer(count: Int)
}

final class AlertPresenter {
	func show(in vc: UIViewController, model: AlertModel) {
		let alert = UIAlertController(
			title: model.title,
			message: model.message,
			preferredStyle: .alert
		)

		alert.view?.accessibilityIdentifier = model.alertIdentifier

		let action = UIAlertAction(
			title: model.buttonText,
			style: .default
		) { _ in
			model.completion()
		}

		action.accessibilityIdentifier = "\(model.alertIdentifier)_action_button"
		alert.addAction(action)

		vc.present(alert, animated: true, completion: nil)
	}
}
