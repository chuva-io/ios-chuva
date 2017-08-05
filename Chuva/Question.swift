import Foundation

protocol BaseQuestion {
    var title: String { get }
    var baseAnswer: BaseAnswer? { get }
}

protocol TypedQuestion: BaseQuestion {
    associatedtype AnswerType: TypedAnswer
    var answer: AnswerType? { get }
}

extension TypedQuestion {
    var baseAnswer: BaseAnswer? {
        get { return answer }
    }
}

// MARK: Question Types

struct Question {

    struct Integer: TypedQuestion {
        let title: String
        var answer: Answer.Integer?
    }

    struct Decimal: TypedQuestion {
        let title: String
        var answer: Answer.Decimal?
    }

    struct Text: TypedQuestion {
        let title: String
        var answer: Answer.Text?
    }

    struct Time: TypedQuestion {
        let title: String
        var answer: Answer.Time?
    }

    struct SingleChoice<T>: TypedQuestion {
        let title: String
        var options: [T]
        var answer: Answer.SingleChoice<T>?
    }

    struct MultipleChoice<T>: TypedQuestion {
        let title: String
        var options: [T]
        var answer: Answer.MultipleChoice<T>?
    }

}
