protocol BaseQuestion: Deserializable {
    var title: String { get }
    var baseAnswer: BaseAnswer? { get }
}

protocol TypedQuestion: BaseQuestion, Serializable {
    associatedtype AnswerType: TypedAnswer
    var answer: AnswerType? { get }
    var type: Question.QuestionType { get }
}

extension TypedQuestion {
    var baseAnswer: BaseAnswer? {
        get { return answer }
    }
}
