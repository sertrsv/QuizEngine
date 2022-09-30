//
//  DelegateSpy.swift
//  
//
//  Created by Sergey Tarasov on 30.09.2022.
//

import QuizEngine

class DelegateSpy: QuizDelegate {
	var questionsAsked: [String] = []
	var answerCompletions: [(String) -> Void] = []

	var completedQuizzes: [[(String, String)]] = []

	func answer(for question: String, completion: @escaping (String) -> Void) {
		self.questionsAsked.append(question)
		self.answerCompletions.append(completion)
	}

	func didCompleteQuiz(withAnswers answers: [(question: String, answer: String)]) {
		completedQuizzes.append(answers)
	}
}
