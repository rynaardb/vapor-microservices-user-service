import Vapor

struct GetUserRequest: Content {
    
    let email: String
    let password: String
}
