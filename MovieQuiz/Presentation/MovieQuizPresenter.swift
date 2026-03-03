import Foundation

struct QuizStepViewModel {
	let image: Data
	let question: String
	let questionNumber: String
}


final class MovieQuizPresenter: QuestionFactoryDelegate {
	let questionsAmount: Int = 10
	private var currentQuestionIndex: Int = 0
	var currentQuestion: QuizQuestion?
	weak var viewController: MovieQuizViewController?
	var questionFactory: QuestionFactoryProtocol?
	var correctAnswers: Int = 0
	
//	init(viewController: MovieQuizViewController) {
//		self.viewController = viewController
//		
//		questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
//		questionFactory?.loadData()
//		viewController.showLoadingIndicator()
//	}
	init(viewController: MovieQuizViewController) {
		self.viewController = viewController
		questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
		questionFactory?.loadData()
		// Безопасный вызов — не вызовет краш, если viewController не готов
		viewController.showLoadingIndicator()
	}
	
	func yesButtonClicked() {
		didAnswer(isYes: true)
	}
	
	func noButtonClicked() {
		didAnswer(isYes: false)
	}
	
	private func didAnswer(isYes: Bool) {
		 guard let currentQuestion = currentQuestion else { return }
		 let isCorrect = isYes == currentQuestion.correctAnswer

		 viewController?.setButtonsEnabled(false)

		 if isCorrect {
			 correctAnswers += 1
		 }

		 viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)


		 DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
			 guard let self = self else { return }
			 self.showNextQuestionOrResult()
		 }
	 }

		func didLoadDataFromServer() {
			viewController?.hideLoadingIndicator()
			questionFactory?.requestNextQuestion()
		}
	
		func didFailToLoadData(with error: Error) {
			let message = error.localizedDescription
			viewController?.showNetworkError(message: message)

		}
	
		func didReceiveNextQuestion(question: QuizQuestion?) {
			guard let question = question else {
				return
			}
			
			currentQuestion = question
			let viewModel = convert(model: question)
			DispatchQueue.main.async { [weak self] in
				self?.viewController?.show(quiz: viewModel)
				self?.viewController?.setButtonsEnabled(true)
			}

		}

	
	func convert(model: QuizQuestion) -> QuizStepViewModel {
		QuizStepViewModel (
			image: model.image,
			question: model.text,
			questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
		)
	}
	
	func isLastQuestion() -> Bool {
		currentQuestionIndex == questionsAmount - 1
	}
	
	func restartGame() {
		currentQuestionIndex = 0
		correctAnswers = 0
		questionFactory?.requestNextQuestion()

	}
	
	func switchToNextQuestion() {
		currentQuestionIndex += 1
	}
	
	func showNextQuestionOrResult() {
		if isLastQuestion() {
			let viewModel = QuizResultsViewModel(
				title: "Этот раунд окончен!",
				text: "",
				buttonText: "Сыграть еще раз")
			viewController?.statisticService.store(correct: correctAnswers, total: questionsAmount)
			self.correctAnswers = 0
			viewController?.showResult(quiz: viewModel)
		} else {
			switchToNextQuestion()
			questionFactory?.requestNextQuestion()
		}
	}

}



