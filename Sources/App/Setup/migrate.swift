import Vapor
import FluentPostgreSQL

public func migrate(migrations: inout MigrationConfig) throws {
    migrations.add(model: User.self, database: .psql)
}
