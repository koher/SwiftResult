# SwiftResult

_SwiftResult_ provides a `Result` type which is compatible with the `Result` type proposed in [SE-0235](https://github.com/apple/swift-evolution/blob/master/proposals/0235-add-result.md), which may be added to the Swift standard library in Swift 5.x. Replacing third-party `Result` types with it may make it easier to migrate your code to Swift 5.x.

```swift
// An overload to return a `Result` instead of `throws`
extension JSONDecoder {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) -> Result<T, DecodingError> {
        ...
    }
}

let person: Result<Person, DecodingError> = JSONDecoder().decode(Person.self, from: json.data(using: .utf8)!)

switch person {
case .value(let person):
    ... // Success
case .error(_):
    ... // Failure
}

let age: Result<Int, DecodingError> = person.map { $0.age }
try! age.unwrapped() // 28
```

## License

[Apache License](LICENSE.txt). It follows [Swift's license](https://github.com/apple/swift/blob/master/LICENSE.txt) and [Swift Evolution's license](https://github.com/apple/swift-evolution/blob/master/LICENSE.txt).
