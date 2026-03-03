import Foundation

protocol MoviesLoading {
	func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

//struct MoviesLoader: MoviesLoading {
//	private let networkClient = NetworkClient()
//	
//	private var mostPopularMoviesUrl: URL {
//		guard let url = URL(string: "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf") else {
//			preconditionFailure("Unable to construct mostPopularMoviesUrl")
//		}
//
//		return url
//	}
//	
//		
//	func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
//		networkClient.fetch(url: mostPopularMoviesUrl) { result in
//			switch result {
//			case .failure(let error):
//				handler(.failure(error))
//				
//			case .success(let data):
//				do {
//					let movies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
//					handler(.success(movies))
//				} catch {
//					handler(.failure(error))
//				}
//			}
//			
//		}
//	}
//}

class MoviesLoader: MoviesLoading {
	private let networkClient = NetworkClient()
	private var currentTask: URLSessionDataTask?
	private var currentTaskId: Int?

	private var mostPopularMoviesUrl: URL? {
		URL(string: "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf")
	}

	func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
		currentTask?.cancel()
		
		guard let url = mostPopularMoviesUrl else {
			handler(.failure(URLError(.badURL)))
			return
		}
		
		let task = networkClient.fetch(url: url) { [weak self] result in
			guard
				let self = self,
				let currentTask = self.currentTask,
				self.currentTaskId == currentTask.taskIdentifier
			else {
				print("Request ignored: task was cancelled or outdated")
				return
			}
			
			switch result {
			case .failure(let error):
				let nsError = error as NSError
				if nsError.domain == NSURLErrorDomain && nsError.code == NSURLErrorCancelled {
					print("Request cancelled, ignoring error")
					return
				}
				handler(.failure(error))
			case .success(let data):
				if data.isEmpty {
					print("Error: received empty data")
					return
				}
				
//				print("Data size: \(data.count) bytes")
				if let jsonString = String(data: data, encoding: .utf8) {
//					print("Response JSON: \(jsonString)")
				}
				
				do {
					let movies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
					handler(.success(movies))
				} catch {
					print("JSON decoding error: \(error)")
					print("Failed to decode data: \(String(data: data, encoding: .utf8) ?? "Invalid UTF-8")")
					handler(.failure(error))
				}
			}
		}
		self.currentTask = task
		self.currentTaskId = task.taskIdentifier
	}
	
	func cancelAllRequests() {
		currentTask?.cancel()
		currentTask = nil
		currentTaskId = nil
	}
}
