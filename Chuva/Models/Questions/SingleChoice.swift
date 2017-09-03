import Eureka

extension Question {
    
    class SingleChoice<T: Hashable & Codable>: TypedQuestion {

        let title: String
        let options: Set<T>
        var answer: Answer.SingleChoice<T>?
        var type: QuestionType = .singleChoice
        
        
        init(title: String, options: Set<T>, answer: Answer.SingleChoice<T>?) {
            self.title = title
            self.options = options
            self.answer = answer
        }
        
        
        // MARK: - Serializable
        static func serialize(_ json: [String : AnyObject]) -> SingleChoice<T>? {
            guard let title = json["title"] as? String,
                let typeString = json["type"] as? String,
                QuestionType(rawValue: typeString) == QuestionType.singleChoice,
                let options = json["options"] as? [T] else {
                    return nil
            }
            
            guard let answerJson = json["answer"] as? [String: AnyObject],
                let answer = Answer.SingleChoice<T>.serialize(answerJson) else {
                    return SingleChoice<T>(title: title, options: Set<T>(options), answer: nil)
            }
            return SingleChoice<T>(title: title, options: Set<T>(options), answer: answer)
        }
        
        
        // MARK: - Deserializable
        func deserialize() -> [String : AnyObject?] {
            return ["title": title as AnyObject,
                    "type": type.rawValue as AnyObject,
                    "options": Array(options) as AnyObject,
                    "answer": answer?.deserialize() as AnyObject]
        }
        
        
        // MARK: - TypedRowRepresentable
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
                print("Question: \(self.title)\nAnswer: \(String(describing: self.answer?.value))")
            }
            return r
        }()
        
    }

}


// MARK: - Protocol Extensions
extension Question.SingleChoice: TypedRowRepresentable { }
