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
                                                                 answer: Answer.SingleChoice<String>(value: "Left"))
        
        let multipleChoiceQuestion = Question.MultipleChoice<String>(title: "Which colors do you like?",
                                                                      options: ["Red", "Blue", "Green", "Yellow"],
                                                                      answer: nil)
        let multipleChoiceAnswer = Answer.MultipleChoice<String>(value: ["Red", "Blue", "Green"])
        multipleChoiceQuestion.answer = multipleChoiceAnswer

        
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(multipleChoiceQuestion)
        
        print(jsonData)
        print(String(data: jsonData, encoding: .utf8)!)
        print("")
        
        jsonEncoder.outputFormatting = .prettyPrinted
        print(try! jsonEncoder.encode(multipleChoiceQuestion))
        print(String(data: try! jsonEncoder.encode(multipleChoiceQuestion), encoding: .utf8)!)
        
        questions = [integerQuestion,
                     decimalQuestion,
                     textQuestion,
                     singleChoiceQuestion]
        
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
    
    func doneActionHandler(vc: CreateFormVC, form: (title: String, questions: [BaseQuestion])) {
        print(form.title)
        print(form.questions)
        vc.dismiss(animated: true)
    }
    
}
