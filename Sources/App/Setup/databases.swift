import Vapor
import FluentPostgreSQL

public func databases(config: inout DatabasesConfig) throws {
    guard let databaseUrl = Environment.get("DATABASE_URL") else {
        throw Abort(.internalServerError)
    }
    guard let dbConfig = PostgreSQLDatabaseConfig(url: databaseUrl) else {
        throw Abort(.internalServerError)
    }
    config.add(database: PostgreSQLDatabase(config: dbConfig), as: .psql)
}
