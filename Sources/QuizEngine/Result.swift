//
//  Result.swift
//  
//
//  Created by Sergey Tarasov on 25.09.2022.
//

public struct Result<Question: Hashable, Answer> {
	public let answers: [Question: Answer]
	public let score: Int

	public init(answers: [Question: Answer], score: Int) {
		self.answers = answers
		self.score = score
	}
}
