import Eureka

extension Question {
 
    class Text: TypedQuestion {
        
        let title: String
        var answer: Answer.Text?
        var type: QuestionType = .text
        
        
        init(title: String, answer: Answer.Text?) {
            self.title = title
            self.answer = answer
        }
        
        
        // MARK: - Serializable
        static func serialize(_ json: [String : AnyObject]) -> Text? {
            guard let title = json["title"] as? String,
                let typeString = json["type"] as? String,
                QuestionType(rawValue: typeString) == QuestionType.text else {
                    return nil
            }
            
            guard let answerJson = json["answer"] as? [String: AnyObject],
                let answer = Answer.Text.serialize(answerJson) else {
                    return Text(title: title, answer: nil)
            }
            return Text(title: title, answer: answer)
        }
        
        
        // MARK: - Deserializable
        func deserialize() -> [String : AnyObject?] {
            return ["title": title as AnyObject,
                    "type": type.rawValue as AnyObject,
                    "answer": answer?.deserialize() as AnyObject]
        }
        
        
        // MARK: - TypedRowRepresentable
        lazy var row: TextRow = {
            if self.answer == nil {
                self.answer = AnswerType(value: nil)    // Cannot be created in onChange block
            }
            let r = TextRow()
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
extension Question.Text: TypedRowRepresentable { }
