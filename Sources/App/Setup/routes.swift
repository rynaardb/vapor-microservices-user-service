import Vapor

public func routes(_ router: Router) throws {
    
    let userController = UserController()
    try router.register(collection: userController)
}
