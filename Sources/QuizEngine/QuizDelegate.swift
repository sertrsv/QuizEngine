//
//  QuizDelegate.swift
//  
//
//  Created by Sergey Tarasov on 29.09.2022.
//
public protocol QuizDelegate {
	associatedtype Question: Hashable
	associatedtype Answer

	func answer(for question: Question, completion: @escaping (Answer) -> Void)

	func didCompleteQuiz(withAnswers: [(question: Question, answer: Answer)])

	@available(*, deprecated, message: "Use didCompleteQuiz(withAnswers:) instead")
	func handle(result: Result<Question, Answer>)
}

public extension QuizDelegate {
	func didCompleteQuiz(withAnswers: [(question: Question, answer: Answer)]) {

	}
}
