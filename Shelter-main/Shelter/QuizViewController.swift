//
//  QuizViewController.swift
//  Shelter
//
//  Created by FSE394 on 4/17/23.
//

import UIKit

class QuizViewController: UIViewController {
    
    
    @IBOutlet var depressionButton: UIButton!
    @IBOutlet var anxietyButton: UIButton!
    @IBOutlet var autismButton: UIButton!
    @IBOutlet var adhdButton: UIButton!
    
    var quiz: Quiz!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtons()
        navigationItem.hidesBackButton = true
        
    }
    
    @IBAction func adhdButtonTapped(_ sender: UIButton) {
        // Set up your quiz questions here
        let questions = [
            Question(text: "How often do you have difficulty sustaining your attention while doing something for work, school, a hobby, or fun activity (e.g., remaining focused during lectures, lengthy reading or conversations)?", choices: ["Never", "Rarely", "Sometimes", "Often"]),
            Question(text: "How often do you avoid, dislike, or are reluctant to engage in tasks that require sustained mental effort or thought?", choices: ["Never", "Rarely", "Sometimes", "Often"]),
            Question(text: "How often do you have difficulty in organizing an activity or task needing to get done (e.g., poor time management, fails to meet deadlines, difficulty managing sequential tasks)?", choices: ["Never", "Rarely", "Sometimes", "Often"]),
            Question(text: "How often do you fail to give close attention to details, or make careless mistakes in things such as schoolwork, at work, or during other activities?", choices: ["Never", "Rarely", "Sometimes", "Often"]),
            Question(text: "How often do you forget to do something you do all the time, such as missing an appointment or paying a bill?", choices: ["Never", "Rarely", "Sometimes", "Often"]),
            Question(text: "How often do you have trouble following through on instructions, or failing to finish schoolwork, chores, or duties in the workplace (e.g., you start a task but quickly lose focus and are easily sidetracked)?", choices: ["Never", "Rarely", "Sometimes", "Often"]),
            Question(text: "How often do you feel like you're 'on the go,' acting as if you're 'driven by a motor' (e.g., you're unable to be or uncomfortable being still for an extended period of time, such as in a restaurant or a meeting)?", choices: ["Never", "Rarely", "Sometimes", "Often"]),
            Question(text: "How often do you leave your seat in situations when remaining seated is expected (e.g., leaving your place in the office or workplace)?", choices: ["Never", "Rarely", "Sometimes", "Often"]),
            Question(text: "How often do you have difficulty waiting your turn, such as while waiting in line?", choices: ["Never", "Rarely", "Sometimes", "Often"]),
            Question(text: "How often do you fidget with or tap your hands or feet, or squirm in your seat?", choices: ["Never", "Rarely", "Sometimes", "Often"])
            // Add more questions
        ]
        
        quiz = Quiz(questions: questions)
        startQuiz()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped(_:)))
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton

    }
    
    @objc func backButtonTapped(_ sender: Any) {
        print(navigationController?.viewControllers ?? [])
        print("Back button tapped")
        navigationController?.popToRootViewController(animated: true)
    }

    
    func startQuiz() {
        quiz.resetQuiz()
        showNextQuestion()
    }

    func showNextQuestion() {
        if let question = quiz.nextQuestion() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let questionVC = storyboard.instantiateViewController(withIdentifier: "QuestionViewController") as! QuestionViewController

            questionVC.question = question
            questionVC.submitAnswer = { [weak self] points in
                self?.quiz.submitAnswer(points: points)
                DispatchQueue.main.async {
                    self?.showNextQuestion()
                }
            }

            navigationController?.pushViewController(questionVC, animated: true)
        } else {
            showQuizResult()
        }
    }

    func showQuizResult() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let resultVC = storyboard.instantiateViewController(withIdentifier: "QuizResultViewController") as! QuizResultViewController

        resultVC.quizResult = quiz.score
        navigationController?.pushViewController(resultVC, animated: true)
    }
    
    func configureButtons() {
        depressionButton.layer.cornerRadius = 25
        depressionButton.layer.masksToBounds = true
        anxietyButton.layer.cornerRadius = 25
        anxietyButton.layer.masksToBounds = true
        autismButton.layer.cornerRadius = 25
        autismButton.layer.masksToBounds = true
        adhdButton.layer.cornerRadius = 25
        adhdButton.layer.masksToBounds = true
        
        
        let depressionText = "Depression" // Replace this with your button title
        let anxietyText = "Anxiety" // Replace this with your button title
        let autismText = "Autism" // Replace this with your button title
        let adhdText = "ADHD" // Replace this with your button title

        let fontSize: CGFloat = 20 // Replace '20' with your desired font size
        let font = UIFont(name: "Inter-Bold", size: fontSize)


        let attributes: [NSAttributedString.Key: Any] = [
            .font: font!
        ]

        let depressionAttributedString = NSAttributedString(string: depressionText, attributes: attributes)
        let anxietyAttributedString = NSAttributedString(string: anxietyText, attributes: attributes)
        let autismAttributedString = NSAttributedString(string: autismText, attributes: attributes)
        let adhdAttributedString = NSAttributedString(string: adhdText, attributes: attributes)

        depressionButton.setAttributedTitle(depressionAttributedString, for: .normal)
        anxietyButton.setAttributedTitle(anxietyAttributedString, for: .normal)
        autismButton.setAttributedTitle(autismAttributedString, for: .normal)
        adhdButton.setAttributedTitle(adhdAttributedString, for: .normal)
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
