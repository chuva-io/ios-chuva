import Foundation

protocol Serializable {
    associatedtype Object
    static func serialize(_ json: [String: AnyObject]) -> Object?
}

extension Serializable {
    static func serialize(_ json: [[String: AnyObject]]) -> [Object?] {
        return json.map { serialize($0) }
    }
}

protocol Deserializable {
    func deserialize() -> [String: AnyObject?]
}
