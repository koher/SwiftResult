# SwiftResult

[![Build Status](https://travis-ci.org/koher/SwiftResult.svg?branch=master)](https://travis-ci.org/koher/SwiftResult)

_SwiftResult_ provides a `Result` type which is compatible with the `Result` type proposed in [SE-0235](https://github.com/apple/swift-evolution/blob/master/proposals/0235-add-result.md) ([announcement about modifications](https://forums.swift.org/t/accepted-with-modifications-se-0235-add-result-to-the-standard-library/18603)), which may be added to the Swift standard library in Swift 5.x. Replacing third-party `Result` types with it may make it easier to migrate your code to Swift 5.x.

```swift
// An overload to return a `Result` instead of `throws`
extension JSONDecoder {
    func decode<T: Decodable>(_ type: T.Type, from json: JSON) -> Result<T, DecodingError> {
        ...
    }
}

let json: JSON = ...

let person: Result<Person, DecodingError> = JSONDecoder().decode(Person.self, from: json)

switch person {
case .success(let person):
    ... // Success
case .failure(let error):
    ... // Failure
}

let age: Result<Int, DecodingError> = person.map { $0.age }
try! age.get() // 28
```

## Installation

### Swift Package Manager

Add the following to `dependencies` in your _Package.swift_.

```swift
.package(
    url: "https://github.com/koher/SwiftResult.git",
    from: "0.2.0"
)
```

### Carthage

```
github "koher/SwiftResult" ~> 0.2.0
```

## License

[Apache License](LICENSE.txt). It follows [Swift's license](https://github.com/apple/swift/blob/master/LICENSE.txt) and [Swift Evolution's license](https://github.com/apple/swift-evolution/blob/master/LICENSE.txt).
