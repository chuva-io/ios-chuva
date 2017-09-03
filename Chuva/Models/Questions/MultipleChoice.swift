import Eureka

extension Question {
    
    class MultipleChoice<T: Hashable & Codable>: TypedQuestion {
        
        let title: String
        var options: Set<T>
        var answer: Answer.MultipleChoice<T>?
        var type: QuestionType = .multipleChoice
        
        init(title: String, options: Set<T>, answer: Answer.MultipleChoice<T>?) {
            self.title = title
            self.options = options
            self.answer = answer
        }
        
        
        // MARK: - Serializable
        static func serialize(_ json: [String : AnyObject]) -> MultipleChoice<T>? {
            guard let title = json["title"] as? String,
                let typeString = json["type"] as? String,
                QuestionType(rawValue: typeString) == QuestionType.multipleChoice,
                let options = json["options"] as? [T] else {
                    return nil
            }
            
            guard let answerJson = json["answer"] as? [String: AnyObject],
                let answer = Answer.MultipleChoice<T>.serialize(answerJson) else {
                    return MultipleChoice<T>(title: title, options: Set<T>(options), answer: nil)
            }
            return MultipleChoice<T>(title: title, options: Set<T>(options), answer: answer)
        }
        
        
        // MARK: - Deserializable
        func deserialize() -> [String : AnyObject?] {
            return ["title": title as AnyObject,
                    "type": type.rawValue as AnyObject,
                    "options": Array(options) as AnyObject,
                    "answer": answer?.deserialize() as AnyObject]
        }
        
        
        // MARK: - TypedRowRepresentable
        lazy var row: MultipleSelectorRow<T> = {
            if self.answer == nil {
                self.answer = AnswerType(value: nil)    // Cannot be created in onChange block
            }
            let r = MultipleSelectorRow<T>()
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
extension Question.MultipleChoice: TypedRowRepresentable { }
