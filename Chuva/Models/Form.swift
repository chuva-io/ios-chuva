struct Form: Serializable, Deserializable {
    let title: String
    let questions: [BaseQuestion]
    
    static func serialize(_ json: [String : AnyObject]) -> Form? {
        guard let title = json["title"] as? String,
        let questionJson = json["questions"] as? [[String: AnyObject]] else {
                return nil
        }
        return Form(title: title, questions: Question.serialize(questionJson).flatMap { $0 })
    }
    
    func deserialize() -> [String : AnyObject?] {
        return ["title": title as AnyObject,
                "questions": questions.map { $0.deserialize() } as AnyObject]
    }
}
