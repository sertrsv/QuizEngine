//
//  ScoreTest.swift
//  
//
//  Created by Sergey Tarasov on 30.09.2022.
//

import XCTest

final class ScoreTest: XCTestCase {

	func test_noAnswers_scoresZero() {
		XCTAssertEqual(BasicScore.score(for: []), 0)
	}

	private class BasicScore {
		static func score(for: [Any]) -> Int {
			return 0
		}
	}

}
