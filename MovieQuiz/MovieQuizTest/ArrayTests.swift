//
//  ArrayTests.swift
//  MovieQuiz
//
import Foundation
import XCTest
//@Testable import MovieQuiz

class ArrayTests: XCTestCase {
	func testGetValueInRange() throws {
		let array = [1, 1, 2, 3, 5]
		
		let value = array[2]
		
		XCTAssertNotNil(value)
		XCTAssertEqual(value, 2)
	}
	
	func testGetValueOutOfRange() throws {
		let array = [1, 1, 2, 3, 5]
		
		let value = array[2]
		
		XCTAssertNotNil(value)
	}
	
}
