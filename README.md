# SwiftResult

[![Build Status](https://travis-ci.org/koher/SwiftResult.svg?branch=master)](https://travis-ci.org/koher/SwiftResult)

_SwiftResult_ provides a `Result` type which is compatible with the `Result` type proposed in [SE-0235](https://github.com/apple/swift-evolution/blob/master/proposals/0235-add-result.md), which may be added to the Swift standard library in Swift 5.x. Replacing third-party `Result` types with it may make it easier to migrate your code to Swift 5.x.

```swift
// An overload to return a `Result` instead of `throws`
extension JSONDecoder {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) -> Result<T, DecodingError> {
        ...
    }
}

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
    ... // Success
case .error(_):
    ... // Failure
}

let age: Result<Int, DecodingError> = person.map { $0.age }
try! age.unwrapped() // 28
```

## Installation

### Swift Package Manager

Add the following to `dependencies` in your _Package.swift_.

```swift
.package(
    url: "https://github.com/koher/SwiftResult.git",
    from: "0.1.0"
)
```

### Carthage

```
github "koher/SwiftResult" ~> 0.1.0
```

## License

[Apache License](LICENSE.txt). It follows [Swift's license](https://github.com/apple/swift/blob/master/LICENSE.txt) and [Swift Evolution's license](https://github.com/apple/swift-evolution/blob/master/LICENSE.txt).
