import Foundation

final class QuestionFactory: QuestionFactoryProtocol {

	private let moviesLoader: MoviesLoading
	private weak var delegate: QuestionFactoryDelegate?
	
	init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate) {
		self.moviesLoader = moviesLoader
		self.delegate = delegate
	}
	
	private var movies: [MostPopularMovie] = []
	
	
	func loadData() {
		moviesLoader.loadMovies { [weak self] result in
			DispatchQueue.main.async {
				guard let self = self else { return }
				switch result {
				case .success(let mostPopularMovies):
					self.movies = mostPopularMovies.items
					self.delegate?.didLoadDataFromServer()
				case .failure(let error):
					self.delegate?.didFailToLoadData(with: error)
				}
			}
		}

	}
	func reset() {
		movies = []
	}
	
	func requestNextQuestion() {
		DispatchQueue.global().async { [weak self] in
			guard let self = self, !self.movies.isEmpty else {
				DispatchQueue.main.async {
					self?.delegate?.didFailToLoadData(with: NSError(domain: "No movies available", code: -1))
				}
				return
			}
			
			let index = (0..<self.movies.count).randomElement() ?? 0
			guard self.movies.indices.contains(index) else { return }
			
			
			let movie = self.movies[index]
			var imageData = Data()
			
			if let resizedImageURL = movie.resizedImageURL {
				do {
					imageData = try Data(contentsOf: resizedImageURL)
				} catch {
					print("Failed to load image: \(error)")
					// Можно использовать заглушку: imageData = UIImage(named: "placeholder")?.pngData() ?? Data()
				}
			}
			
			let rating = Float(movie.rating) ?? 0
			let text = "Рейтинг этого фильма больше чем 7?"
			let correctAnswer = rating > 7
			
			let question = QuizQuestion(image: imageData, text: text, correctAnswer: correctAnswer)
			
			DispatchQueue.main.async { [weak self] in
				guard let self = self else { return }
				self.delegate?.didReceiveNextQuestion(question: question)
			}
		}
	}
	
//	func requestNextQuestion() {
//		DispatchQueue.global().async { [weak self] in
//			guard let self = self else { return }
//			let index = (0..<self.movies.count).randomElement() ?? 0
//			
//			
//			guard self.movies.indices.contains(index) else {
//				print("Index \(index) is invalid")
//				return
//			}
//
//			let movie = self.movies[index]
//			
//			var imageData = Data()
//			if let resizedImageURL = movie.resizedImageURL {
//				do {
//					imageData = try Data(contentsOf: resizedImageURL)
//				} catch {
//					print("Failed to load image from URL: \(resizedImageURL), error: \(error)")
//				}
//			} else {
//				print("Movie has no image URL")
//			}
//			
//			let rating = Float(movie.rating) ?? 0
//			
//			let text = "Рейтинг этого фильма больше чем 7?"
//			let correctAnswer = rating > 7
//			
//			
//			let question = QuizQuestion(image: imageData,
//								  text: text,
//								  correctAnswer: correctAnswer)
//			
//			DispatchQueue.main.async { [weak self] in
//				guard let self = self else { return }
//				self.delegate?.didReceiveNextQuestion(question: question)
//			}
//		}
//	}
}


//	private var allQuestions: [QuizQuestion] = [
//		QuizQuestion(
//			image: "The Godfather",
//			text: "Рейтинг этого фильма больше чем 6?",
//			correctAnswer: true),
//
//		QuizQuestion(
//			image: "The Dark Knight",
//			text: "Рейтинг этого фильма больше чем 6?",
//			correctAnswer: true),
//
//		QuizQuestion(
//			image: "Kill Bill",
//			text: "Рейтинг этого фильма больше чем 6?",
//			correctAnswer: true),
//
//		QuizQuestion(
//			image: "The Avengers",
//			text: "Рейтинг этого фильма больше чем 6?",
//			correctAnswer: true),
//
//		QuizQuestion(
//			image: "Deadpool",
//			text: "Рейтинг этого фильма больше чем 6?",
//			correctAnswer: true),
//
//		QuizQuestion(
//			image: "The Green Knight",
//			text: "Рейтинг этого фильма больше чем 6?",
//			correctAnswer: true),
//
//		QuizQuestion(
//			image: "Old",
//			text: "Рейтинг этого фильма больше чем 6?",
//			correctAnswer: false),
//
//		QuizQuestion(
//			image: "The Ice Age Adventures of Buck Wild",
//			text: "Рейтинг этого фильма больше чем 6?",
//			correctAnswer: false),
//
//		QuizQuestion(
//			image: "Tesla",
//			text: "Рейтинг этого фильма больше чем 6?",
//			correctAnswer: false),
//
//		QuizQuestion(
//			image: "Vivarium",
//			text: "Рейтинг этого фильма больше чем 6?",
//			correctAnswer: false),
//	]
