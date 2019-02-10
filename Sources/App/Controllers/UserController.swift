import Vapor
import Crypto

struct UserController: RouteCollection {
    
    func boot(router: Router) throws {
        let usersRouter = router.grouped("users")
        
        usersRouter.post(CreateUserRequest.self, at: "", use: register)
        usersRouter.post(GetUserRequest.self, at: "login", use: getUser)
    }
}

private extension UserController {
    
    func register(_ req: Request, createRequest: CreateUserRequest) throws -> Future<HTTPStatus> {
        let userRepository = try req.make(UserRepository.self)
        return try userRepository.findCount(username: createRequest.username, email: createRequest.email, on: req).flatMap { count in
            guard count == 0 else {
                throw Abort(.badRequest, reason: "A user with these credentials allready exists.")
            }
            try createRequest.validate()
            let bcrypt = try req.make(BCryptDigest.self)
            let hashedPassword = try bcrypt.hash(createRequest.password)
            let user = User(username: createRequest.username, email: createRequest.email, password: hashedPassword)
            return try userRepository.save(user: user, on: req).transform(to: HTTPStatus.created)
        }
    }
    
    func getUser(_ req: Request, getRequest: GetUserRequest) throws -> Future<GetUserResponse> {
        let userRepository = try req.make(UserRepository.self)
        return try userRepository.find(email: getRequest.email, on: req).map { user in
            guard let user = user else {
                throw Abort(.unauthorized, reason: "Invalid credentials.")
            }
            let bcrypt = try req.make(BCryptDigest.self)
            guard try bcrypt.verify(getRequest.password, created: user.password) else {
                throw Abort(.unauthorized, reason: "Invalid credentials.")
            }
            return try GetUserResponse(id: user.requireID(), username: user.username, email: user.email)
        }
    }
}
