import UIKit
import Eureka

class ViewController: FormViewController {
    
    var questions: [BaseQuestion] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let integerAnswer = Answer.Integer(value: 45)
        let integerQuestion = Question.Integer(title: "How old are you?", answer: integerAnswer)
        
        let decimalQuestion = Question.Decimal(title: "How much do you weigh?", answer: nil)
        decimalQuestion.answer = Answer.Decimal(value: 123.45)
        
        let textQuestion = Question.Text(title: "What is your name?", answer: nil)
        textQuestion.answer = Answer.Text(value: "Nilson")

        let singleChoiceQuestion = Question.SingleChoice<String>(title: "Which hand do you write with?",
                                                                 options: Set(["Left", "Right"]),
                                                                 answer: nil)
        
        let multipleChoiceQuestion = Question.MultipleChoice<UIColor>(title: "Which colors do you like?",
                                                                      options: [.red, .blue, .green, .yellow],
                                                                      answer: nil)
        let multipleChoiceAnswer = Answer.MultipleChoice<UIColor>(value: [.red, .green, .yellow])
        multipleChoiceQuestion.answer = multipleChoiceAnswer

        
        questions = [integerQuestion,
                     decimalQuestion,
                     textQuestion,
                     singleChoiceQuestion,
                     multipleChoiceQuestion]
        
        var section = Eureka.Section()
        section += questions
            .flatMap { $0 as? BaseRowRepresentable }
            .map { $0.baseRow }
        form +++ section
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        let newFormVC = CreateFormVC()
        newFormVC.delegate = self
        
        let navVC = UINavigationController(rootViewController: newFormVC)
        present(navVC, animated: true)
    }
    
    @IBAction func submitButtonTapped() {
        for question in questions {
            print("Question: \(question.title)\nAnswer: \(String(describing: question.baseAnswer?.baseValue))")
            print("")
        }
    }
    
}

extension ViewController: CreateFormDelegate {
    func cancelActionHandler(vc: CreateFormVC) {
        vc.dismiss(animated: true)
    }
    
    func doneActionHandler(vc: CreateFormVC, form: [BaseQuestion]) {
        print(form)
        vc.dismiss(animated: true)
    }
    
}
