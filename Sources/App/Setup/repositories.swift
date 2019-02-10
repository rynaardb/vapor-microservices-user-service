import Vapor

public func setupRepositories(services: inout Services, config: inout Config) {
    services.register(UserRepository.self) { _ -> PostgreUserRepository in
        return PostgreUserRepository()
    }
    
    preferDatabaseRepositories(config: &config)
}

private func preferDatabaseRepositories(config: inout Config) {
    config.prefer(PostgreUserRepository.self, for: UserRepository.self)
}
