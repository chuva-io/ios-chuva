import Foundation

struct Answer {

    struct Integer: TypedAnswer {
        var value: Int?

        init(value: Value?) {
            self.value = value
            self.baseValue = baseValue
        }
    }

    struct Decimal: TypedAnswer {
        var value: Double?

        init(value: Value?) {
            self.value = value
            self.baseValue = baseValue
        }
    }

    struct Text: TypedAnswer {
        var value: String?

        init(value: Value?) {
            self.value = value
            self.baseValue = baseValue
        }
    }

    struct Time: TypedAnswer {
        var value: Date?

        init(value: Value?) {
            self.value = value
            self.baseValue = baseValue
        }
    }

    struct SingleChoice<T: Hashable>: TypedAnswer {
        var value: T?

        init(value: Value?) {
            self.value = value
            self.baseValue = baseValue
        }
    }

    struct MultipleChoice<T: Hashable>: TypedAnswer {
        var value: Set<T>?

        init(value: Value?) {
            self.value = value
            self.baseValue = baseValue
        }
    }

}
