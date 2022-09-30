//
//  QuizDelegate.swift
//  
//
//  Created by Sergey Tarasov on 29.09.2022.
//

public protocol QuizDelegate {
	associatedtype Question
	associatedtype Answer

	func answer(for question: Question, completion: @escaping (Answer) -> Void)

	func didCompleteQuiz(withAnswers: [(question: Question, answer: Answer)])
}
