import Foundation

struct Answer {

    struct Integer: TypedAnswer {
        var value: Int?

        init(value: Value?) {
            self.value = value
            self.baseValue = baseValue
        }
        
        static func serialize(_ json: [String: AnyObject]) -> Integer? {
            guard let value = json["value"] as? Int else {
                return nil
            }
            return Integer(value: value)
        }
    }

    struct Decimal: TypedAnswer {
        var value: Double?

        init(value: Value?) {
            self.value = value
            self.baseValue = baseValue
        }
        
        static func serialize(_ json: [String: AnyObject]) -> Decimal? {
            guard let value = json["value"] as? Double else {
                return nil
            }
            return Decimal(value: value)
        }
    }

    struct Text: TypedAnswer {
        var value: String?

        init(value: Value?) {
            self.value = value
            self.baseValue = baseValue
        }
        
        static func serialize(_ json: [String: AnyObject]) -> Text? {
            guard let value = json["value"] as? String else {
                return nil
            }
            return Text(value: value)
        }
    }

    struct SingleChoice<T: Hashable & Codable>: TypedAnswer {
        var value: T?

        init(value: Value?) {
            self.value = value
            self.baseValue = baseValue
        }
        
        static func serialize(_ json: [String: AnyObject]) -> SingleChoice<T>? {
            guard let value = json["value"] as? T else {
                return nil
            }
            return SingleChoice<T>(value: value)
        }
    }

    struct MultipleChoice<T: Hashable & Codable>: TypedAnswer {
        var value: Set<T>?

        init(value: Value?) {
            self.value = value
            self.baseValue = baseValue
        }
        
        static func serialize(_ json: [String: AnyObject]) -> MultipleChoice<T>? {
            guard let value = json["value"] as? Set<T> else {
                return nil
            }
            return MultipleChoice<T>(value: value)
        }
        
        func deserialize() -> [String : AnyObject?] {
            guard let value = value else {
                return ["value": nil]
            }
            return ["value": Array(value) as AnyObject]
            
        }
    }

}
