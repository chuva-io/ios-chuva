import Foundation
import Eureka

// MARK: Protocol Extensions

extension Question.Integer: TypedRowRepresentable { }
extension Question.Decimal: TypedRowRepresentable { }
extension Question.Text: TypedRowRepresentable { }
//extension Question.Time: TypedRowRepresentable { }
extension Question.SingleChoice: TypedRowRepresentable { }
extension Question.MultipleChoice: TypedRowRepresentable { }

// MARK: Question Types

struct Question {

    class Integer: TypedQuestion {
        let title: String
        var answer: Answer.Integer?

        lazy var row: IntRow = {
            if self.answer == nil {
                self.answer = AnswerType(value: nil)    // Cannot be created in onChange block
            }
            let r = IntRow()
            r.title = self.title
            r.value = self.answer?.value
            r.onChange { _ in
                self.answer?.value = r.value
                print("Question: \(self.title)\n Answer: \(String(describing: self.answer?.value))")
            }
           return r
        }()

        init(title: String, answer: Answer.Integer?) {
            self.title = title
            self.answer = answer
        }
    }

    class Decimal: TypedQuestion {
        let title: String
        var answer: Answer.Decimal?

        lazy var row: DecimalRow = {
            if self.answer == nil {
                self.answer = AnswerType(value: nil)    // Cannot be created in onChange block
            }
            let r = DecimalRow()
            r.title = self.title
            r.value = self.answer?.value
            r.onChange {_ in
                self.answer?.value = r.value
                print("Question: \(self.title)\n Answer: \(String(describing: self.answer?.value))")
            }
            return r
        }()

        init(title: String, answer: Answer.Decimal?) {
            self.title = title
            self.answer = answer
        }
    }

    class Text: TypedQuestion {
        let title: String
        var answer: Answer.Text?

        lazy var row: TextRow = {
            if self.answer == nil {
                self.answer = AnswerType(value: nil)    // Cannot be created in onChange block
            }
            let r = TextRow()
            r.title = self.title
            r.value = self.answer?.value
            r.onChange {_ in
                self.answer?.value = r.value
                print("Question: \(self.title)\n Answer: \(String(describing: self.answer?.value))")
            }
            return r
        }()

        init(title: String, answer: Answer.Text?) {
            self.title = title
            self.answer = answer
        }
    }

//    class Time: TypedQuestion {
//        let title: String
//        var answer: Answer.Time?
//    }

    class SingleChoice<T: Hashable>: TypedQuestion {
        let title: String
        let options: Set<T>
        var answer: Answer.SingleChoice<T>?

        lazy var row: PushRow<T> = {
            if self.answer == nil {
                self.answer = AnswerType(value: nil)    // Cannot be created in onChange block
            }
            let r = PushRow<T>()
            r.title = self.title
            r.options = Array(self.options)
            r.value = self.answer?.value
            r.onChange { _ in
                self.answer?.value = r.value
                print("Question: \(self.title)\n Answer: \(String(describing: self.answer?.value))")
            }
            return r
        }()

        init(title: String, options: Set<T>, answer: Answer.SingleChoice<T>?) {
            self.title = title
            self.options = options
            self.answer = answer
        }
    }

    class MultipleChoice<T: Hashable>: TypedQuestion {
        let title: String
        var options: Set<T>
        var answer: Answer.MultipleChoice<T>?

        lazy var row: MultipleSelectorRow<T> = {
            if self.answer == nil {
                self.answer = AnswerType(value: nil)    // Cannot be created in onChange block
            }
            let r = MultipleSelectorRow<T>()
            r.title = self.title
            r.options = Array(self.options)
            r.value = self.answer?.value
            r.onChange { _ in
                self.answer?.value = r.value
                print("Question: \(self.title)\n Answer: \(String(describing: self.answer?.value))")
            }
            return r
        }()

        init(title: String, options: Set<T>, answer: Answer.MultipleChoice<T>?) {
            self.title = title
            self.options = options
            self.answer = answer
        }
    }

}
