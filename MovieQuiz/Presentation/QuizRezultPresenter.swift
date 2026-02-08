class QuizRezultPresenter: QuizResultProtocol {
	func makeResultsMessage() -> String {
		return "Вы ответили на \(correctAnswer) из \(questionsAmount), попробуйте еще раз"
	}

	func restartGame() {
	}

}
