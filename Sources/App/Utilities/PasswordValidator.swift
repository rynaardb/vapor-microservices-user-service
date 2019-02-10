import Validation

extension Validator where T == String {
    /// Validates whether a `String` is a valid password.
    ///
    ///     try validations.add(\.password, .password)
    ///
    public static var password: Validator<T> {
        return PasswordValidator().validator()
    }
}

// MARK: Private

/// Validates whether a string is a valid password.
fileprivate struct PasswordValidator: ValidatorType {
    /// See `ValidatorType`.
    public var validatorReadable: String {
        return "a valid password"
    }
    
    /// Creates a new `PasswordValidator`.
    public init() {}
    
    /// See `Validator`.
    public func validate(_ s: String) throws {
        guard s.range(of: "(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).{8,}", options: [.regularExpression, .caseInsensitive]) != nil
            else {
                throw BasicValidationError("is not a valid password")
        }
    }
}
