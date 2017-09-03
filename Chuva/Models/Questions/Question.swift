struct Question: Serializable {
    
    enum QuestionType: String {
        case integer
        case decimal
        case text
        case singleChoice
        case multipleChoice
    }
    
    static func serialize(_ json: [String: AnyObject]) -> BaseQuestion? {
        guard let typeString = json["type"] as? String,
            let type = QuestionType(rawValue: typeString) else {
                return nil
        }
        
        switch type {
        
        case .integer:
            return Question.Integer.serialize(json)
        
        case .decimal:
            return Question.Decimal.serialize(json)
        
        case .text:
            return Question.Text.serialize(json)
        
        case .singleChoice:
            return Question.SingleChoice<String>.serialize(json)
        
        case .multipleChoice:
            return Question.MultipleChoice<String>.serialize(json)
        
        }
        
    }
    
    static func serialize(_ json: [[String: AnyObject]]) -> [BaseQuestion?] {
        return json.map { serialize($0) }
    }
    
}
