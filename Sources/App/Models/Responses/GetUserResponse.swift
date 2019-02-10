import Vapor

struct GetUserResponse: Content {
    
    let id: UUID
    let username: String
    let email: String
    
    init(id: UUID, username: String, email: String) {
        self.id = id
        self.username = username
        self.email = email
    }
}
