import Foundation

enum JSON {
    indirect case object([String: JSON])
    indirect case array([JSON])
    case number(Double)
    case string(String)
    case boolean(Bool)
    case null
}

extension JSON {
    func jsonObject() -> Any {
        switch self {
        case .object(let object):
            var jsonObject: [String: Any] = [:]
            for (key, value) in object {
                jsonObject[key] = value.jsonObject()
            }
            return jsonObject
        case .array(let array):
            return array.map { $0.jsonObject() }
        case .number(let number):
            return number
        case .string(let string):
            return string
        case .boolean(let boolean):
            return boolean
        case .null:
            return NSNull()
        }
    }
    
    func data(options: JSONSerialization.WritingOptions = []) -> Data {
        let jsonObject = self.jsonObject()
        assert(JSONSerialization.isValidJSONObject(jsonObject))
        return try! JSONSerialization.data(withJSONObject: jsonObject, options: options)
    }
}
