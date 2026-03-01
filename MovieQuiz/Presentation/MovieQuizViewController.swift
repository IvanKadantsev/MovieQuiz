import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
	
	// MARK: - Lifecycle
	
	
	@IBOutlet private var imageView: UIImageView!
	@IBOutlet private var textLabel: UILabel!
	@IBOutlet private var counterLabel: UILabel!
	@IBOutlet weak var noButton: UIButton!
	@IBOutlet weak var yesButton: UIButton!
	@IBOutlet private var activityIndicator: UIActivityIndicatorView!
	
//	private var correctAnswers = 0
	
	private let presenter = MovieQuizPresenter()
	var questionFactory: QuestionFactory?


	private var currentQuestion: QuizQuestion?
	
	private var alertPresenter = AlertPresenter()
	private var quizResultPresenter: QuizResultProtocol

	var statisticService: StatisticServiceProtocol!
	
	init(
		presenter: QuizResultProtocol,
	) {
		self.quizResultPresenter = presenter
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		let presenter = QuizResultPresenter(correctAnswer: 0, questionsAmount: 10)
		self.quizResultPresenter = presenter
		super.init(coder: coder)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		
		questionFactory = QuestionFactory(
			moviesLoader: MoviesLoader(),
			delegate: self
		)

		presenter.viewController = self
		presenter.questionFactory = questionFactory
		imageView.layer.cornerRadius = 20
		statisticService = StatisticService()
		showLoadingIndicator()
		questionFactory?.loadData()
		
	}
	
	private func showLoadingIndicator() {
		activityIndicator.isHidden = false
		activityIndicator.startAnimating()
	}

	private func showNetworkError(message: String) {
		showLoadingIndicator()
		
		let model = AlertModel(title: "Ошибка",
								message: message,
							   buttonText: "Попробовать еще раз", alertIdentifier: "Error") { [weak self] in
			guard let self = self else {return}
			
			self.presenter.resetQuestionIndex()
			self.presenter.correctAnswers = 0
		}
		alertPresenter.show(in: self, model: model)
	}
	
	func didLoadDataFromServer() {
		activityIndicator.isHidden = true
		questionFactory?.requestNextQuestion()
	}
	
	func didFailToLoadData(with error: Error) {
		showNetworkError(message: error.localizedDescription)
	}
	
	func didReceiveNextQuestion(question: QuizQuestion?) {
		presenter.didReceiveNextQuestion(question: question)
	}

	func show(quiz step: QuizStepViewModel) {
		imageView.image = UIImage(data: step.image) ?? UIImage()
		textLabel.text = step.question
		counterLabel.text = step.questionNumber
		imageView.layer.borderWidth = 0
	}
	
	@IBAction private func noButtonClicked(_ sender: UIButton) {
		presenter.noButtonClicked()
	}
		
	@IBAction private func yesButtonClicked(_ sender: UIButton) {
		presenter.yesButtonClicked()
	}
		
	func showAnswerResult(isCorrect: Bool) {
		if isCorrect {presenter.correctAnswers += 1}
		quizResultPresenter.updateCorrectAnswer(count: presenter.correctAnswers)
		imageView.layer.masksToBounds = true
		imageView.layer.borderWidth = 8
		imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
		imageView.layer.cornerRadius = 20
		noButton.isEnabled = false
		yesButton.isEnabled = false
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
			guard let self = self else {return}
			self.noButton.isEnabled = true
			self.yesButton.isEnabled = true
//			self.presenter.correctAnswers = self.correctAnswers
//			self.presenter.questionFactory = self.questionFactory
			presenter.showNextQuestionOrResult()
		}
		
	}
		
	func showResult(quiz result: QuizResultsViewModel) {
		let message = quizResultPresenter.makeResultsMessage()
		let model = AlertModel(
			title: result.title,
			message: message,
			buttonText: result.buttonText,
			alertIdentifier: "Game results") { [weak self] in
			guard let self = self else {return}
			self.quizResultPresenter.restartGame()
			self.questionFactory?.reset()
				self.presenter.correctAnswers = 0
				self.presenter.resetQuestionIndex()
			self.questionFactory?.requestNextQuestion()
			self.startNewGame()
				
		}
		alertPresenter.show(in: self, model: model)
	}
	
	private func startNewGame() {
		questionFactory?.reset()
		presenter.correctAnswers = 0
		presenter.resetQuestionIndex()
		questionFactory?.loadData()
	}

}
	

/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */

//private struct ViewModel {
//  let image: UIImage
//  let question: String
//  let questionNumber: String
//}

//private struct QuizStepViewModel {
//	let image: UIImage
//	let question: String
//	let questionNumber: String
//}


//private struct QuizResultViewModel {
//	let title: String
//	let text: String
//	let buttonText: String
//}
