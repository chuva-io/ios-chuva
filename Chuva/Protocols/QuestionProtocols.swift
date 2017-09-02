protocol BaseQuestion: Codable {
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
