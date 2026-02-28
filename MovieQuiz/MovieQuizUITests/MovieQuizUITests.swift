//
//  MovieQuizUITests.swift
//  MovieQuizUITests


import XCTest

final class MovieQuizUITests: XCTestCase {
	
	var app: XCUIApplication!
	
    override func setUpWithError() throws {
		try super.setUpWithError()
		
		app = XCUIApplication()
		app.launch()
		
        continueAfterFailure = false


    }

    override func tearDownWithError() throws {
		try super.tearDownWithError()
		
//		app.terminate()
		app = nil
    }
	
//	func testScreenCast() throws {
//		let app = XCUIApplication()
//
//		app.activate()
//		app/*@START_MENU_TOKEN@*/.buttons["Да"]/*[[".buttons.containing(.staticText, identifier: \"Да\")",".otherElements.buttons[\"Да\"]",".buttons[\"Да\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//
//		app/*@START_MENU_TOKEN@*/.buttons["Нет"]/*[[".buttons.containing(.staticText, identifier: \"Нет\")",".otherElements.buttons[\"Нет\"]",".buttons[\"Нет\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//		
//	}

	func testYesButton() {
		sleep(3)
		let firstPoster = app.images["Poster"]
//		XCTAssertTrue(firstPoster.exists)
		let firstPosterData = firstPoster.screenshot().pngRepresentation
		app.buttons["Yes"].tap()
		sleep(3)
		let secondPoster = app.images["Poster"]
//		XCTAssertTrue(secondPoster.exists)
		let secondPosterData = secondPoster.screenshot().pngRepresentation
//		XCTAssertFalse(firstPoster == secondPoster)
		XCTAssertFalse(firstPosterData == secondPosterData)
		let indexLabel = app.staticTexts["Index"]
		XCTAssertEqual(indexLabel.label, "2/10")
	}
	
	func testNoButton() {
		sleep(3)
		let firstPoster = app.images["Poster"]
//		XCTAssertTrue(firstPoster.exists)
		let firstPosterData = firstPoster.screenshot().pngRepresentation
		app.buttons["No"].tap()
		sleep(3)
		let secondPoster = app.images["Poster"]
//		XCTAssertTrue(secondPoster.exists)
		let secondPosterData = secondPoster.screenshot().pngRepresentation
//		XCTAssertFalse(firstPoster == secondPoster)
		XCTAssertFalse(firstPosterData == secondPosterData)
		let indexLabel = app.staticTexts["Index"]
		XCTAssertEqual(indexLabel.label, "2/10")
	}

	func testGameFinish() {
		sleep(2)
		for _ in 1...10{
			app.buttons["Yes"].tap()
			sleep(2)
		}
		
		let alert = app.alerts["Game results"]
		
		XCTAssertTrue(alert.exists)
		XCTAssertTrue(alert.label == "Этот раунд окончен!")
		XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть еще раз")
	}
	
	func testAlertDismiss() {
		sleep(2)
		for _ in 1...10{
			app.buttons["Yes"].tap()
			sleep(2)
		}
		
		let alert = app.alerts["Game results"]
		alert.buttons.firstMatch.tap()
		
		sleep(2)
		
		let indexLabel = app.staticTexts["Index"]
		
		XCTAssertFalse(alert.exists)
		XCTAssertTrue(indexLabel.label == "1/10")
	}
	
    func testExample() throws {
 
        let app = XCUIApplication()
        app.launch()


    }
}
