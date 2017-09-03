import Eureka

extension Question {
    
    class Decimal: TypedQuestion {
        
        let title: String
        var answer: Answer.Decimal?
        var type: QuestionType = .decimal
        
        
        init(title: String, answer: Answer.Decimal?) {
            self.title = title
            self.answer = answer
        }
        
        
        // MARK: - Serializable
        static func serialize(_ json: [String : AnyObject]) -> Decimal? {
            return Decimal(title: "Decimal Title", answer: nil)
        }
        
        
        // MARK: - Deserializable
        func deserialize() -> [String : AnyObject?] {
            return ["title": title as AnyObject,
                    "type": type.rawValue as AnyObject,
                    "answer": answer?.deserialize() as AnyObject]
        }
        
        
        // MARK: - TypedRowRepresentable
        lazy var row: DecimalRow = {
            if self.answer == nil {
                self.answer = AnswerType(value: nil)    // Cannot be created in onChange block
            }
            let r = DecimalRow()
            r.title = self.title
            r.value = self.answer?.value
            r.onChange {_ in
                self.answer?.value = r.value
                print("Question: \(self.title)\nAnswer: \(String(describing: self.answer?.value))")
            }
            return r
        }()
        
    }
    
}


// MARK: - Protocol Extensions
extension Question.Decimal: TypedRowRepresentable { }
