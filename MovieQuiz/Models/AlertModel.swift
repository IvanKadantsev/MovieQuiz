import Foundation

struct AlertModel {
	var title: String
	var message: String
	var buttonText: String
	let alertIdentifier: String
	var completion:() -> Void
}
