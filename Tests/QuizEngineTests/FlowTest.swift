//
//  FlowTest.swift
//  
//
//  Created by Sergey Tarasov on 25.09.2022.
//

import XCTest
@testable import QuizEngine

final class FlowTest: XCTestCase {

	func test_start_withNoQuestions_doesNotDelegateQuestionHandling() throws {
		makeSUT(questions: []).start()

		XCTAssertTrue(delegate.questionsAsked.isEmpty)
	}

	func test_start_withOneQuestions_delegatesCorrectQuestionHandling() throws {
		makeSUT(questions: ["Q1"]).start()

		XCTAssertEqual(delegate.questionsAsked, ["Q1"])
	}

	func test_start_withOneQuestions_delegatesAnotherCorrectQuestionHandling() throws {
		makeSUT(questions: ["Q2"]).start()

		XCTAssertEqual(delegate.questionsAsked, ["Q2"])
	}

	func test_start_withTwoQuestions_delegatesFirstQuestionHandling() throws {
		makeSUT(questions: ["Q1", "Q2"]).start()

		XCTAssertEqual(delegate.questionsAsked, ["Q1"])
	}

	func test_startTwice_withTwoQuestions_delegatesFirstQuestionHandlingTwice() throws {
		let sut = makeSUT(questions: ["Q1", "Q2"])

		sut.start()
		sut.start()

		XCTAssertEqual(delegate.questionsAsked, ["Q1", "Q1"])
	}

	func test_startAndAnswerFirstAndSecondQuestions_withThreeQuestions_delegatesSecondAndThirdQuestionHandling() throws {
		let sut = makeSUT(questions: ["Q1", "Q2", "Q3"])

		sut.start()
		delegate.answerCompletions[0]("A1")
		delegate.answerCompletions[1]("A2")

		XCTAssertEqual(delegate.questionsAsked, ["Q1", "Q2", "Q3"])
	}

	func test_startAndAnswerFirstQuestion_withOneQuestion_doesNotDelegateAnotherQuestionHandling() throws {
		let sut = makeSUT(questions: ["Q1"])
		sut.start()

		delegate.answerCompletions[0]("A1")

		XCTAssertEqual(delegate.questionsAsked, ["Q1"])
	}

	func test_start_withOneQuestion_doesNotCompleteQuiz() throws {
		makeSUT(questions: ["Q1"]).start()

		XCTAssertTrue(delegate.completedQuizzes.isEmpty)
	}

	func test_start_withNoQuestions_completeWithEmptyQuiz() throws {
		makeSUT(questions: []).start()

		XCTAssertEqual(delegate.completedQuizzes.count, 1)
		XCTAssertTrue(delegate.completedQuizzes[0].isEmpty)
	}

	func test_startAndAnswerFirstQuestion_withTwoQuestions_doesNotCompleteQuiz() throws {
		let sut = makeSUT(questions: ["Q1", "Q2"])
		sut.start()

		delegate.answerCompletions[0]("A1")

		XCTAssertTrue(delegate.completedQuizzes.isEmpty)
	}

	func test_startAndAnswerFirstAndSecondQuestions_withTwoQuestions_completesQuiz() throws {
		let sut = makeSUT(questions: ["Q1", "Q2"])
		sut.start()

		delegate.answerCompletions[0]("A1")
		delegate.answerCompletions[1]("A2")

		XCTAssertEqual(delegate.completedQuizzes.count, 1)
		assertEqual(delegate.completedQuizzes[0], [("Q1", "A1"), ("Q2", "A2")])
	}

	// MARK: Helpers

	private let delegate = DelegateSpy()

	weak private var weakSUT: Flow<DelegateSpy>?

	override func tearDown() {
		super.tearDown()

		XCTAssertNil(weakSUT, "Memory leak detected. Weak reference to the SUT instance is not nil.")
	}

	private func makeSUT(
		questions: [String]
	) -> Flow<DelegateSpy> {
		let sut = Flow(delegate: delegate, questions: questions)
		weakSUT = sut
		return sut
	}

	private func assertEqual(
		_ a1: [(String, String)],
		_ a2: [(String, String)],
		file: StaticString = #filePath,
		line: UInt = #line
	) {
		XCTAssertTrue(a1.elementsEqual(a2, by: ==), "\(a1) is not equal to \(a2)", file: file, line: line)
	}

	private class DelegateSpy: QuizDelegate {
		var questionsAsked: [String] = []
		var answerCompletions: [(String) -> Void] = []
		
		var handledResult: Result<String, String>? = nil
		var completedQuizzes: [[(String, String)]] = []

		func answer(for question: String, completion: @escaping (String) -> Void) {
			self.questionsAsked.append(question)
			self.answerCompletions.append(completion)
		}

		func didCompleteQuiz(withAnswers answers: [(question: String, answer: String)]) {
			completedQuizzes.append(answers)
		}

		func handle(result: Result<String, String>) {
			self.handledResult = result
		}
	}

}
