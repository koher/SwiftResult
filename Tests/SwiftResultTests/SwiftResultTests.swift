import XCTest
@testable import SwiftResult

final class SwiftResultTests: XCTestCase {
    func testExample() {
        let json = """
        {
            "firstName": "Albert",
            "lastName": "Einstein",
            "age": 28
        }
        """
        
        let person: Result<Person, DecodingError> = JSONDecoder().decode(Person.self, from: json.data(using: .utf8)!)
        
        switch person {
        case .value(let person):
            XCTAssertEqual(person.age, 28)
        case .error(_):
            XCTFail()
        }
        
        let age: Result<Int, DecodingError> = person.map { $0.age }
        XCTAssertEqual(try! age.unwrapped(), 28)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}

struct Person: Codable {
    var firstName: String
    var lastName: String
    var age: Int
}

extension JSONDecoder {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) -> Result<T, DecodingError> {
        do {
            return .value(try self.decode(T.self, from: data))
        } catch let error as DecodingError {
            return .error(error)
        } catch _ {
            preconditionFailure()
        }
    }
}
