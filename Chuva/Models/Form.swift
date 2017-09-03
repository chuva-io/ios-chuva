struct Form: Deserializable {
    let title: String
    let questions: [BaseQuestion]
    
    func deserialize() -> [String : AnyObject?] {
        return ["title": title as AnyObject,
                "questions": questions.map { $0.deserialize() } as AnyObject]
    }
}
