//
//  Quiz.swift
//  Shelter
//
//  Created by FSE394 on 4/20/23.
//

import Foundation

struct Question {
    let text: String
    let choices: [String] // ["Never", "Rarely", "Sometimes", "Often"]
}

class Quiz {
    private(set) var questions: [Question]
    private(set) var currentQuestionIndex: Int = 0
    private(set) var score: Int = 0

    init(questions: [Question]) {
        self.questions = questions
    }

    func nextQuestion() -> Question? {
        guard currentQuestionIndex < questions.count else { return nil }
        let question = questions[currentQuestionIndex]
        currentQuestionIndex += 1
        return question
    }

    func submitAnswer(points: Int) {
        score += points
    }

    func resetQuiz() {
        currentQuestionIndex = 0
        score = 0
    }
}
