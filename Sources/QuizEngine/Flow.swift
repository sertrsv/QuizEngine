//
//  Flow.swift
//  
//
//  Created by Sergey Tarasov on 25.09.2022.
//

class Flow <Delegate: QuizDelegate> {
	typealias Question = Delegate.Question
	typealias Answer = Delegate.Answer

	private let delegate: Delegate
	private let questions: [Question]
	private var newAnswers: [(Question, Answer)] = []
	private var answers: [Question: Answer] = [:]
	private var scoring: ([Question: Answer]) -> Int

	init(delegate: Delegate, questions: [Question], scoring: @escaping ([Question: Answer]) -> Int = { _ in 0 }) {
		self.delegate = delegate
		self.questions = questions
		self.scoring = scoring
	}

	func start() {
		delegateQuestionHandling(at: questions.startIndex)
	}

	private func delegateQuestionHandling(at index: Int) {
		if index < questions.endIndex {
			let question = questions[index]
			delegate.answer(for: question, completion: answer(for: question, at: index))
		} else {
			delegate.didCompleteQuiz(withAnswers: newAnswers)
			delegate.handle(result: result())
		}
	}

	private func delegateQuestionHandling(after index: Int) {
		delegateQuestionHandling(at: questions.index(after: index))
	}

	private func answer(for question: Question, at index: Int) -> (Answer) -> Void {
		return { [weak self] answer in
			self?.newAnswers.append((question, answer))
			self?.answers[question] = answer
			self?.delegateQuestionHandling(after: index)
		}
	}

	private func result() -> Result<Question, Answer> {
		return Result(answers: answers, score: scoring(answers))
	}
}
