import XCTest
@testable import SwiftResult

final class SwiftResultTests: XCTestCase {
    func testMap() {
        do {
            let a: Result<Int, Error1> = .success(3)
            let r: Result<Double, Error1> = a.map { Double($0 * $0) }
            XCTAssertEqual(r, .success(9.0))
        }
        
        do {
            let a: Result<Int, Error1> = .failure(Error1(a: 42))
            let r: Result<Double, Error1> = a.map { Double($0 * $0) }
            XCTAssertEqual(r, .failure(Error1(a: 42)))
        }
    }
    
    func testMapError() {
        do {
            let a: Result<Int, Error1> = .success(3)
            let r: Result<Int, Error2> = a.mapError { e in Error2(b: e.a >= 0) }
            XCTAssertEqual(r, .success(3))
        }
        
        do {
            let a: Result<Int, Error1> = .failure(Error1(a: 42))
            let r: Result<Int, Error2> = a.mapError { e in Error2(b: e.a >= 0) }
            XCTAssertEqual(r, .failure(Error2(b: true)))
        }
    }
    
    func testFlatMap() {
        do {
            let a: Result<Int, Error1> = .success(3)
            let r: Result<Double, Error1> = a.flatMap { .success(Double($0 * $0)) }
            XCTAssertEqual(r, .success(9.0))
        }
        
        do {
            let a: Result<Int, Error1> = .failure(Error1(a: 42))
            let r: Result<Double, Error1> = a.flatMap { .success(Double($0 * $0)) }
            XCTAssertEqual(r, .failure(Error1(a: 42)))
        }
    }
    
    func testFlatMapError() {
        do {
            let a: Result<Int, Error1> = .success(3)
            let r: Result<Int, Error2> = a.flatMapError { e in .failure(Error2(b: e.a >= 0)) }
            XCTAssertEqual(r, .success(3))
        }
        
        do {
            let a: Result<Int, Error1> = .failure(Error1(a: 42))
            let r: Result<Int, Error2> = a.flatMapError { e in .failure(Error2(b: e.a >= 0)) }
            XCTAssertEqual(r, .failure(Error2(b: true)))
        }
    }
    
    func testUnwrapped() {
        do {
            let a: Result<Int, Error1> = .success(3)
            let r: Int = try a.get()
            XCTAssertEqual(r, 3)
        } catch let error {
            XCTFail("\(type(of: error)): \(error)")
        }
        
        do {
            let a: Result<Int, Error1> = .failure(Error1(a: 42))
            let r: Int = try a.get()
            XCTFail("\(r)")
        } catch let error as Error1 {
            XCTAssertEqual(error, Error1(a: 42))
        } catch let error {
            XCTFail("\(type(of: error)): \(error)")
        }
    }
    
    func testInit() {
        do {
            let jsonData: Data = "[42]".data(using: .utf8)!
            let result = Result<[Int], Error> { try JSONDecoder().decode([Int].self, from: jsonData) }
            switch result {
            case .success(let value):
                XCTAssertEqual(value, [42])
            case .failure(let error):
                XCTFail("\(type(of: error)): \(error)")
            }
        }
        
        do {
            let jsonData: Data = "".data(using: .utf8)!
            let result = Result<[Int], Error> { try JSONDecoder().decode([Int].self, from: jsonData) }
            switch result {
            case .success(let value):
                XCTFail("\(value)")
            case .failure(DecodingError.dataCorrupted(let context)):
                XCTAssertTrue(context.codingPath.isEmpty)
            case .failure(let error):
                XCTFail("\(type(of: error)): \(error)")
            }
        }
    }
    
    func testExample() {
        let json: JSON = .object([
            "firstName": .string("Albert"),
            "lastName": .string("Einstein"),
            "age": .number(28),
        ])
        
        let person: Result<Person, DecodingError> = JSONDecoder().decode(Person.self, from: json)
        
        switch person {
        case .success(let person):
            XCTAssertEqual(person.age, 28)
        case .failure(let error):
            XCTFail("\(error)")
        }
        
        let age: Result<Int, DecodingError> = person.map { $0.age }
        XCTAssertEqual(try! age.get(), 28)
    }

    static var allTests = [
        ("testMap", testMap),
        ("testMapError", testMapError),
        ("testFlatMap", testFlatMap),
        ("testFlatMapError", testFlatMapError),
        ("testUnwrapped", testUnwrapped),
        ("testInit", testInit),
        ("testExample", testExample),
    ]
}

struct Person: Codable {
    var firstName: String
    var lastName: String
    var age: Int
}

extension JSONDecoder {
    func decode<T: Decodable>(_ type: T.Type, from json: JSON) -> Result<T, DecodingError> {
        do {
            return .success(try self.decode(T.self, from: json.data()))
        } catch let error as DecodingError {
            return .failure(error)
        } catch _ {
            preconditionFailure()
        }
    }
}

struct Error1: Error, Equatable {
    let a: Int
}
struct Error2: Error, Equatable {
    let b: Bool
}
