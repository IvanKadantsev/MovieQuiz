import UIKit

//final class AlertPresenter {
//	func show(in vc: UIViewController, model: AlertModel) {
//
//		let alert = UIAlertController(
//			title: nil, //model.title
//			message: nil, //model.message
//			preferredStyle: .alert)
//		
//		let paragraphStyle = NSMutableParagraphStyle()
//		paragraphStyle.alignment = .center
//		paragraphStyle.lineBreakMode = .byWordWrapping
//
//		let titleAttributes: [NSAttributedString.Key: Any] = [
//			.font: UIFont.boldSystemFont(ofSize: 17),      // жирный, 17 pt
//			.foregroundColor: UIColor.black,                 // чёрный цвет
//			.paragraphStyle: paragraphStyle                  // выравнивание по центру
//		]
//		let attributedTitle = NSAttributedString(
//			 string: model.title,
//			 attributes: titleAttributes
//		 )
//		 alert.setValue(attributedTitle, forKey: "attributedTitle")
//
//		let messageAttributes: [NSAttributedString.Key: Any] = [
//			 .font: UIFont.systemFont(ofSize: 13),  // шрифт 13 pt
//			 .foregroundColor: UIColor.black,             // цвет текста сообщения
//			 .paragraphStyle: paragraphStyle
//		 ]
//		 let attributedMessage = NSAttributedString(string: model.message, attributes: messageAttributes)
//		 alert.setValue(attributedMessage, forKey: "attributedMessage")
//		
//		let action = UIAlertAction(title: model.buttonText, style: .default) { _ in model.completion()
//		}
//		
//		alert.addAction(action)
//
//		print("Title attributes: \(titleAttributes)")
//		print("Message attributes: \(messageAttributes)")
//		vc.present(alert, animated: true, completion: nil)
//	}
//}

protocol QuizResultProtocol {
	func makeResultsMessage() -> String
	func restartGame()
	func updateCorrectAnswer(count: Int)
}

//final class CustomAlertViewController: UIViewController {
//	
//	private let titleText: String
//	private let messageText: String
//	private let actionTitle: String
//	private let completion: () -> Void
//	private let alertIdentifier: String
//	
//	private lazy var backgroundView: UIView = {
//		let view = UIView()
//		view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
//		view.isUserInteractionEnabled = true
//		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
//		view.addGestureRecognizer(tapGesture)
//		return view
//	}()
//	
//	private lazy var alertContainer: UIView = {
//		let view = UIView()
//		view.backgroundColor = .white
//		view.layer.cornerRadius = 16
//		view.clipsToBounds = true
//		return view
//	}()
//	private lazy var titleLabel: UILabel = {
//		let label = UILabel()
//		label.font = UIFont.boldSystemFont(ofSize: 17)
//		label.textColor = .black
//		label.textAlignment = .center
//		label.numberOfLines = 0
//		label.lineBreakMode = .byWordWrapping
//		return label
//	}()
//	private lazy var messageLabel: UILabel = {
//		let label = UILabel()
//		label.font = UIFont.systemFont(ofSize: 13)
//		label.textColor = .black
//		label.textAlignment = .center
//		label.numberOfLines = 0
//		label.lineBreakMode = .byWordWrapping
//		return label
//	}()
//	private lazy var actionButton: UIButton = {
//		let button = UIButton(type: .system)
//		button.setTitle(actionTitle, for: .normal)
//		button.setTitleColor(.systemBlue, for: .normal)
//		button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
//		button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
//		return button
//	}()
//	
//	init(title: String, message: String, actionTitle: String, completion: @escaping () -> Void) {
//		self.titleText = title
//		self.messageText = message
//		self.actionTitle = actionTitle
//		self.alertIdentifier = alertIdentifier
//		self.completion = completion
//		super.init(nibName: nil, bundle: nil)
//		modalPresentationStyle = .overFullScreen
//	}
//	
//	required init?(coder: NSCoder) {
//		fatalError("init(coder:) has not been implemented")
//	}
//	
//	override func viewDidLoad() {
//		super.viewDidLoad()
//		setupViews()
//		configureLabels()
//	}
//	
//	override func viewWillAppear(_ animated: Bool) {
//		super.viewWillAppear(animated)
//		alertContainer.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
//	}
//	
//	override func viewDidAppear(_ animated: Bool) {
//		super.viewDidAppear(animated)
//		UIView.animate(withDuration: 0.2) {
//			self.alertContainer.transform = .identity
//		}
//	}
//	
//	private func setupViews() {
//		view.addSubview(backgroundView)
//		backgroundView.addSubview(alertContainer)
//		[titleLabel, messageLabel, actionButton].forEach { alertContainer.addSubview($0) }
//		setupConstraints()
//		
//		alertContainer.accessibilityIdentifier = "\(alertIdentifier)_container"
//		titleLabel.accessibilityIdentifier = "\(alertIdentifier)_title"
//		messageLabel.accessibilityIdentifier = "\(alertIdentifier)_message"
//		actionButton.accessibilityIdentifier = "\(alertIdentifier)_action_button"
//
//	}
//	
//	private func configureLabels() {
//		titleLabel.text = titleText
//		messageLabel.text = messageText
//	}
//	
//	private func setupConstraints() {
//		backgroundView.translatesAutoresizingMaskIntoConstraints = false
//		NSLayoutConstraint.activate([
//			backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
//			backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//			backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//			backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//		])
//		
//		alertContainer.translatesAutoresizingMaskIntoConstraints = false
//		NSLayoutConstraint.activate([
//			alertContainer.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
//			alertContainer.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
//			alertContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
//			alertContainer.heightAnchor.constraint(lessThanOrEqualToConstant: 400)
//		])
//		
//		titleLabel.translatesAutoresizingMaskIntoConstraints = false
//		NSLayoutConstraint.activate([
//			titleLabel.topAnchor.constraint(equalTo: alertContainer.topAnchor, constant: 24),
//			titleLabel.leadingAnchor.constraint(equalTo: alertContainer.leadingAnchor, constant: 24),
//			titleLabel.trailingAnchor.constraint(equalTo: alertContainer.trailingAnchor, constant: -24)
//		])
//		
//		messageLabel.translatesAutoresizingMaskIntoConstraints = false
//		NSLayoutConstraint.activate([
//			messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
//			messageLabel.leadingAnchor.constraint(equalTo: alertContainer.leadingAnchor, constant: 24),
//			messageLabel.trailingAnchor.constraint(equalTo: alertContainer.trailingAnchor, constant: -24)
//		])
//		
//		actionButton.translatesAutoresizingMaskIntoConstraints = false
//		NSLayoutConstraint.activate([
//			actionButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 24),
//			actionButton.leadingAnchor.constraint(equalTo: alertContainer.leadingAnchor, constant: 24),
//			actionButton.trailingAnchor.constraint(equalTo: alertContainer.trailingAnchor, constant: -24),
//			actionButton.bottomAnchor.constraint(equalTo: alertContainer.bottomAnchor, constant: -24),
//			actionButton.heightAnchor.constraint(equalToConstant: 50)
//		])
//	}
//	
//	@objc private func backgroundTapped() {
//		dismiss(animated: true, completion: nil)
//	}
//	@objc private func actionButtonTapped() {
//		completion()
//		dismiss(animated: true, completion: nil)
//	}
//}

//final class AlertPresenter {
//	func show(in vc: UIViewController, model: AlertModel) {
//		let alert = UIViewController(
//			title: model.title,
//			message: model.message,
//			preferredStyle: .alert
//		)
//		
//		alert.accessibilityIdentifier = model.alertIdentifier
//		
//		let action = UIAlertAction(
//								   title: model.buttonText,
//								   style: .default) { _ in
//			model.completion()
//		}
//		action.accessibilityIdentifier = "\(model.alertIdentifier)_action_button"
//		
//		alert.addAction(action)
// 
//		
//		vc.present(alert, animated: true, completion: nil)
//	}
//}


final class AlertPresenter {
	func show(in vc: UIViewController, model: AlertModel) {
		let alert = UIAlertController(
			title: model.title,
			message: model.message,
			preferredStyle: .alert
		)

		// Установка идентификатора через view
		alert.view?.accessibilityIdentifier = model.alertIdentifier

		let action = UIAlertAction(
			title: model.buttonText,
			style: .default
		) { _ in
			model.completion()
		}

		action.accessibilityIdentifier = "\(model.alertIdentifier)_action_button"
		alert.addAction(action)

		vc.present(alert, animated: true, completion: nil)
	}
}
