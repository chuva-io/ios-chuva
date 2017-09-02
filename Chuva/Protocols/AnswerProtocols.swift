protocol BaseAnswer: Codable {
    var baseValue: Any? { get set }
}

protocol TypedAnswer: BaseAnswer {
    associatedtype Value: Hashable
    var value: Value? { get set }
    init(value: Value?)
}

extension TypedAnswer {
    var baseValue: Any? {
        set { value = newValue as? Value }
        get { return value }
    }

    init(value: Value?) {
        self.init(value: value)
        self.value = value
        self.baseValue = baseValue
    }
}
