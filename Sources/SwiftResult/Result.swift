/// A value that represents either a success or failure, capturing associated
/// values in both cases.
public enum Result<Success, Failure/*: Error*/> {
    /// A normal result, storing a `Value`.
    case success(Success)
    
    /// An error result, storing an `Error`.
    case failure(Failure)
    
    /// Evaluates the given transform closure when this `Result` instance is
    /// `.success`, passing the value as a parameter.
    ///
    /// Use the `map` method with a closure that returns a non-`Result` value.
    ///
    /// - Parameter transform: A closure that takes the successful value of the
    ///   instance.
    /// - Returns: A new `Result` instance with the result of the transform, if
    ///   it was applied.
    public func map<NewValue>(
        _ transform: (Success) -> NewValue
    ) -> Result<NewValue, Failure> {
        switch self {
        case .success(let value):
            return .success(transform(value))
        case .failure(let error):
            return .failure(error)
        }
    }
    
    /// Evaluates the given transform closure when this `Result` instance is
    /// `.failure`, passing the error as a parameter.
    ///
    /// Use the `mapError` method with a closure that returns a non-`Result`
    /// value.
    ///
    /// - Parameter transform: A closure that takes the failure value of the
    ///   instance.
    /// - Returns: A new `Result` instance with the result of the transform, if
    ///   it was applied.
    public func mapError<NewError>(
        _ transform: (Failure) -> NewError
    ) -> Result<Success, NewError> {
        switch self {
        case .success(let value):
            return .success(value)
        case .failure(let error):
            return .failure(transform(error))
        }
    }
    
    /// Evaluates the given transform closure when this `Result` instance is
    /// `.success`, passing the value as a parameter and flattening the result.
    ///
    /// - Parameter transform: A closure that takes the successful value of the
    ///   instance.
    /// - Returns: A new `Result` instance, either from the transform or from
    ///   the previous error value.
    public func flatMap<NewValue>(
        _ transform: (Success) -> Result<NewValue, Failure>
    ) -> Result<NewValue, Failure> {
        switch self {
        case .success(let value):
            return transform(value)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    /// Evaluates the given transform closure when this `Result` instance is
    /// `.failure`, passing the error as a parameter and flattening the result.
    ///
    /// - Parameter transform: A closure that takes the error value of the
    ///   instance.
    /// - Returns: A new `Result` instance, either from the transform or from
    ///   the previous success value.
    public func flatMapError<NewError>(
        _ transform: (Failure) -> Result<Success, NewError>
    ) -> Result<Success, NewError> {
        switch self {
        case .success(let value):
            return .success(value)
        case .failure(let error):
            return transform(error)
        }
    }
}

extension Result where Failure: Error {
    /// Unwraps the `Result` into a throwing expression.
    ///
    /// - Returns: The success value, if the instance is a success.
    /// - Throws:  The error value, if the instance is a failure.
    public func get() throws -> Success {
        switch self {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
}

extension Result where Failure == Error {
    /// Create an instance by capturing the output of a throwing closure.
    ///
    /// - Parameter throwing: A throwing closure to evaluate.
    @_transparent
    public init(catching body: () throws -> Success) {
        do {
            self = .success(try body())
        } catch let error {
            self = .failure(error)
        }
    }
}

extension Result : Equatable where Success : Equatable, Failure : Equatable { }

extension Result : Hashable where Success : Hashable, Failure : Hashable { }
