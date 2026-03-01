import Foundation
import UIKit

struct QuizStepViewModel {
	let image: Data
	let question: String
	let questionNumber: String
}


final class MovieQuizPresenter {
	let questionsAmount: Int = 10
	private var currentQuestionIndex: Int = 0

	
	
	func convert(model: QuizQuestion) -> QuizStepViewModel {
		QuizStepViewModel (
//			image: UIImage(data: model.image) ?? UIImage(),
			image: model.image,
			question: model.text,
			questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
		)
	}
	
	func isLartQuestion() -> Bool {
		currentQuestionIndex == questionsAmount - 1
	}
	
	func resetQuestionIndex() {
		currentQuestionIndex = 0
	}
	
	func switchToNextQuestion() {
		currentQuestionIndex += 1
	}

}



