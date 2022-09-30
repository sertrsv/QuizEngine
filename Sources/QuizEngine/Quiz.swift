//
//  Quiz.swift
//  
//
//  Created by Sergey Tarasov on 29.09.2022.
//

public final class Quiz {
	private let flow: Any

	init(flow: Any) {
		self.flow = flow
	}

	public static func start<Delegate: QuizDelegate>(
		questions: [Delegate.Question],
		delegate: Delegate
	) -> Quiz where Delegate.Answer: Equatable {
		let flow = Flow(
			delegate: delegate,
			questions: questions
		)
		flow.start()
		return Quiz(flow: flow)
	}
}
