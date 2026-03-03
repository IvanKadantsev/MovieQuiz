import UIKit
import XCTest
@testable import MovieQuiz


final class MovieQuizTests: XCTestCase {
	
}

class MovieQuizPresenterConvertTests: XCTestCase {
	private var presenter: MovieQuizPresenter!
	private var stubController: TestMovieQuizViewController!

	override func setUp() {
		super.setUp()

		let quizResultPresenter = QuizResultPresenter(correctAnswer: 0, questionsAmount: 10)
		

		stubController = TestMovieQuizViewController(presenter: quizResultPresenter)
		
		presenter = MovieQuizPresenter(viewController: stubController)
		presenter.questionFactory = nil
	}

	class TestMovieQuizViewController: MovieQuizViewController {
		override func loadView() {
			view = UIView() // Пустой view без загрузки из nib
		}

		override func showLoadingIndicator() {}
		override func hideLoadingIndicator() {}
		override func show(quiz step: QuizStepViewModel) {}
		override func showResult(quiz result: QuizResultsViewModel) {}
		override func highlightImageBorder(isCorrectAnswer: Bool) {}
		override func showNetworkError(message: String) {}
	}

	func testConvert_WhenValidQuizQuestion_ReturnsCorrectViewModel() {
		// Arrange
		let imageFileName = "Deadpol.jpg"
		let imageData = imageFileName.data(using: .utf8)!

		let questionTest = QuizQuestion(
			image: imageData,
			text: "Рейтинг этого фильма больше чем 7?",
			correctAnswer: true
		)

		// Act
		let result = presenter.convert(model: questionTest)

		// Assert
		XCTAssertEqual(result.image, imageData)
		XCTAssertEqual(result.question, "Рейтинг этого фильма больше чем 7?")
		XCTAssertEqual(result.questionNumber, "1/10")
	}
}
