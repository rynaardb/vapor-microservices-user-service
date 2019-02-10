import Vapor

struct CreateUserRequest: Content, Reflectable {
    
    let username: String
    let email: String
    let password: String
}

extension CreateUserRequest: Validatable {
    
    static func validations() throws -> Validations<CreateUserRequest> {
    var validations = Validations(CreateUserRequest.self)
        try validations.add(\.username, .alphanumeric && .count(3...))
        try validations.add(\.email, .email)
        try validations.add(\.password, .password)
        return validations
    }
}
