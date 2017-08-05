import Foundation

protocol BaseAnswer {
    var baseValue: Any? { get set }
}

protocol TypedAnswer: BaseAnswer {
    associatedtype Value
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

// MARK: Answer Types

struct Answer {
    
    struct Integer: TypedAnswer {
        var value: Int?
    }
    
    struct Decimal: TypedAnswer {
        var value: Double?
    }
    
    struct Text: TypedAnswer {
        var value: String?
    }
    
    struct Time: TypedAnswer {
        var value: Date?
    }
    
    struct SingleChoice<T>: TypedAnswer {
        var value: T?
    }
    
    struct MultipleChoice<T>: TypedAnswer {
        var value: [T]?
    }
    
}
