//
//  ViewController.swift
//  Chuva
//
//  Created by Nilson Nascimento on 7/23/17.
//  Copyright © 2017 Chuva. All rights reserved.
//

import UIKit
import Eureka

class ViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let integerAnswer = Answer.Integer(value: 45)
        var integerQuestion = Question.Integer(title: "How old are you?", answer: integerAnswer)
        
        var decimalQuestion = Question.Decimal(title: "How much do you weigh?", answer: nil)
        decimalQuestion.answer = Answer.Decimal(value: 123.45)
        
        var textQuestion = Question.Text(title: "What is your name?", answer: nil)
        textQuestion.answer = Answer.Text(value: "Nilson")

        var singleChoiceQuestion = Question.SingleChoice<String>(title: "Which hand do you write with?",
                                                                 options: ["Left", "Right"],
                                                                 answer: nil)
        
        var multipleChoiceQuestion = Question.MultipleChoice<UIColor>(title: "Which colors do you like?",
                                                                      options: [.red, .blue, .green, .yellow],
                                                                      answer: nil)
        let multipleChoiceAnswer = Answer.MultipleChoice<UIColor>(value: [.red, .green, .yellow])
        multipleChoiceQuestion.answer = multipleChoiceAnswer

        
        let questions: [BaseQuestion] = [integerQuestion,
                                         decimalQuestion,
                                         textQuestion,
                                         singleChoiceQuestion,
                                         multipleChoiceQuestion]
        
        for question in questions {
            print("Question: \(question.title)")
            print("Answer: \(question.baseAnswer?.baseValue ?? "No answer")\n\n")
        }
        
        form +++ Section()
            <<< PushRow<String>("0.0") {
                $0.title = singleChoiceQuestion.title
                $0.value = singleChoiceQuestion.answer?.value
                $0.options = singleChoiceQuestion.options
                $0.onChange {
                    singleChoiceQuestion.answer?.value = $0.value
                    print("Row \($0.tag!) value: \(String(describing: singleChoiceQuestion.answer?.value))")
                    self.dismiss(animated: true)
                }
            }
            <<< MultipleSelectorRow<UIColor>("1") {
                $0.title = multipleChoiceQuestion.title
                $0.value = Set(multipleChoiceQuestion.answer?.value ?? [])
                $0.options = multipleChoiceQuestion.options
                $0.onChange {
                    multipleChoiceQuestion.answer?.value = Array($0.value ?? [])
                    print("Row \($0.tag!) value: \(String(describing: multipleChoiceQuestion.answer?.value))")
                    self.dismiss(animated: true)
                }
            }
            <<< DecimalRow("2") {
                $0.title = decimalQuestion.title
                $0.value = decimalQuestion.answer?.value
                $0.onChange {
                    decimalQuestion.answer?.value = $0.value
                    print("Row \($0.tag!) value: \(String(describing: decimalQuestion.answer?.value))")
                }
            }
            <<< IntRow("3") {
                $0.title = integerQuestion.title
                $0.value = integerQuestion.answer?.value
                $0.onChange {
                    integerQuestion.answer?.value = $0.value
                    print("Row \($0.tag!) value: \(String(describing: integerQuestion.answer?.value))")
                }
            }
            <<< TextRow("5"){
                $0.title = textQuestion.title
                $0.value = textQuestion.answer?.value
                $0.placeholder = "Enter text here"
                $0.onChange {
                    textQuestion.answer?.value = $0.value
                    print("Row \($0.tag!) value: \(String(describing: textQuestion.answer?.value))")
                }
            }
//            <<< TimeRow("6"){
//                $0.title = "What time did you wake up?"
//                $0.onChange {
//                    print("Row \($0.tag!) value: \(String(describing: $0.value))")
//                }
//            }
//            <<< DateRow("7") {
//                $0.title = "What's todays date?"
//                $0.onChange {
//                    print("Row \($0.tag!) value: \(String(describing: $0.value))")
//                }
//            }
//            <<< DateTimeRow("8") {
//                $0.title = "When's your next meeting?"
//                $0.onChange {
//                    print("Row \($0.tag!) value: \(String(describing: $0.value))")
//                }
//        }
        
    }
    
    @IBAction func submitButtonTapped() {
        print(form.values())
    }
    
}
