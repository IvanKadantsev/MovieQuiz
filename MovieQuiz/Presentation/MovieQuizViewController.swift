import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
	// MARK: - Lifecycle
	
	
	@IBOutlet private var imageView: UIImageView!
	@IBOutlet private var textLabel: UILabel!
	@IBOutlet private var counterLabel: UILabel!
	@IBOutlet weak var noButton: UIButton!
	@IBOutlet weak var yesButton: UIButton!
	@IBOutlet private var activityIndicator: UIActivityIndicatorView!
	
	private var currentQuestionIndex: Int = 0
	private var correctAnswer = 0

	private let questionsAmount: Int = 10
	private lazy var questionFactory: QuestionFactoryProtocol = {
		return QuestionFactory(
			moviesLoader: MoviesLoader(),
			delegate: self)
	} ()
	private var currentQuestion: QuizQuestion?
	
	private var alertPresenter = AlertPresenter()
	private var presenter: QuizResultProtocol

	var statisticService: StatisticServiceProtocol!
	
	init(
		presenter: QuizResultProtocol,
//		questionFactory: QuestionFactoryProtocol
	) {
		self.presenter = presenter
//		self.questionFactory = questionFactory
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		let presenter = QuizResultPresenter(correctAnswer: 0, questionsAmount: 10)
//		let factory = QuestionFactory(
//			moviesLoader: MoviesLoader(),
//			delegate: self
//		)
		self.presenter = presenter
//		self.questionFactory = factory
		super.init(coder: coder)
	}

	override func viewDidLoad() {
//		super.viewDidLoad()
//		let questionFactory = QuestionFactory()
//		questionFactory.setup(delegate: self)
//		self.questionFactory = questionFactory
//		questionFactory.requestNextQuestion()
//		statisticService = StatisticService()
//		

			super.viewDidLoad()
		   
		   imageView.layer.cornerRadius = 20
//			questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
			statisticService = StatisticService()

			showLoadingIndicator()
			questionFactory.loadData()
		
	}
	
	private func showLoadingIndicator() {
		activityIndicator.isHidden = false
		activityIndicator.startAnimating()
	}

	private func showNetworkError(message: String) {
		showLoadingIndicator()
		
		let model = AlertModel(title: "Ошибка",
								message: message,
								buttonText: "Попробовать еще раз") { [weak self] in
			guard let self = self else {return}
			
			self.currentQuestionIndex = 0
			self.correctAnswer = 0
		}
		alertPresenter.show(in: self, model: model)
	}
	
	func didLoadDataFromServer() {
		activityIndicator.isHidden = true
		questionFactory.requestNextQuestion()
	}
	
	func didFailToLoadData(with error: Error) {
		showNetworkError(message: error.localizedDescription)
	}

	func didReceiveNextQuestion(question: QuizQuestion?) {
		guard let question = question else {
			return
		}
		currentQuestion = question
		let viewModel = convert(model: question)
		DispatchQueue.main.async { [weak self] in
			self?.show(quiz: viewModel)
		}
	}
	
//	private func convert(model: QuizQuestion) -> QuizStepViewModel {
//		let questionStep = QuizStepViewModel(
//			image: UIImage(named: model.image) ?? UIImage(),
//			question: model.text,
//			questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
//		return questionStep
//	}
	
	private func convert(model: QuizQuestion) -> QuizStepViewModel {
		return QuizStepViewModel(
			image: UIImage(data: model.image) ?? UIImage(),
			question: model.text,
			questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
	}
	
	private func show(quiz step: QuizStepViewModel) {
		imageView.image = step.image
		textLabel.text = step.question
		counterLabel.text = step.questionNumber
		imageView.layer.borderWidth = 0
	}
	
	@IBAction private func noButtonClicked(_ sender: UIButton) {
		print(currentQuestionIndex, questionsAmount, correctAnswer)
		guard currentQuestionIndex != questionsAmount else {
			return
		}
		let givenAnswer = false
		showAnswerResult(isCorrect: givenAnswer == currentQuestion?.correctAnswer)
	}
		
	@IBAction private func yesButtonClicked(_ sender: UIButton) {
		print(currentQuestionIndex, questionsAmount, correctAnswer)
		guard currentQuestionIndex != questionsAmount else {
			return
		}
		let givenAnswer = true
		showAnswerResult(isCorrect: givenAnswer == currentQuestion?.correctAnswer)
	}
		
	private func showAnswerResult(isCorrect: Bool) {
		if isCorrect {correctAnswer += 1}
		presenter.updateCorrectAnswer(count: correctAnswer)
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
			self.showNextQuestionOrResult()
		}
		
	}
	
	private func showNextQuestionOrResult() {
		if currentQuestionIndex == questionsAmount - 1 {
			let viewModel = QuizResultsViewModel(
				title: "Этот раунд окончен!",
				text: "",
				buttonText: "Сыграть еще раз")
			statisticService.store(correct: correctAnswer, total: questionsAmount)
			correctAnswer = 0
			currentQuestionIndex = 0
			show(quiz: viewModel)
		} else {
			currentQuestionIndex += 1
			questionFactory.requestNextQuestion()
		}
	}
	
	
	private func show(quiz result: QuizResultsViewModel) {
		let message = presenter.makeResultsMessage()
		let model = AlertModel(
			title: result.title,
			message: message,
			buttonText: result.buttonText) { [weak self] in
			guard let self = self else {return}
			self.presenter.restartGame()
			self.questionFactory.reset()
			self.correctAnswer = 0
			self.currentQuestionIndex = 0
			self.questionFactory.requestNextQuestion()
			self.startNewGame()
				
		}
		alertPresenter.show(in: self, model: model)
	}
	
	private func startNewGame() {
		questionFactory.reset()
		correctAnswer = 0
		currentQuestionIndex = 0
		questionFactory.loadData()
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
