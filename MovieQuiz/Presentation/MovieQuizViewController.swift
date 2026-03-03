import UIKit

class MovieQuizViewController: UIViewController, MovieQuizControllerProtocol {
	
	// MARK: - Lifecycle
	
	
	@IBOutlet private var imageView: UIImageView!
	@IBOutlet private var textLabel: UILabel!
	@IBOutlet private var counterLabel: UILabel!
	@IBOutlet weak var noButton: UIButton!
	@IBOutlet weak var yesButton: UIButton!
	@IBOutlet private var activityIndicator: UIActivityIndicatorView!
	
	private var presenter: MovieQuizPresenter!

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

//	override func viewDidLoad() {
//		super.viewDidLoad()
//		
//		presenter = MovieQuizPresenter(viewController: self)
////		presenter.viewController = self
//		imageView.layer.cornerRadius = 20
//		statisticService = StatisticService()
//		showLoadingIndicator()
//	}

	override func viewDidLoad() {
		super.viewDidLoad()
		print("MovieQuizViewController: viewDidLoad called")
		imageView.layer.cornerRadius = 20
		statisticService = StatisticService()
		presenter = MovieQuizPresenter(viewController: self)
		print("MovieQuizPresenter created and assigned")
		showLoadingIndicator()
	}
	
	func showLoadingIndicator() {
		activityIndicator.isHidden = false
		activityIndicator.startAnimating()
	}

	func showNetworkError(message: String) {
		showLoadingIndicator()
		
		let model = AlertModel(title: "Ошибка",
								message: message,
							   buttonText: "Попробовать еще раз", alertIdentifier: "Error") { [weak self] in
			guard let self = self else {return}
			
			self.presenter.restartGame()
		}
		alertPresenter.show(in: self, model: model)
	}

	
	func setButtonsEnabled(_ enabled: Bool) {
	 noButton.isEnabled = enabled
	 yesButton.isEnabled = enabled
	}
	
	func hideLoadingIndicator() {
		activityIndicator.isHidden = true
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
		
	func highlightImageBorder(isCorrectAnswer: Bool) {
		imageView.layer.masksToBounds = true
		imageView.layer.borderWidth = 8
		imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
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
				self.presenter.correctAnswers = 0
				self.presenter.restartGame()
		}
		alertPresenter.show(in: self, model: model)
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
