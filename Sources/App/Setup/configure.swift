import Vapor
import FluentPostgreSQL

public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    
    try services.register(FluentPostgreSQLProvider())
    
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    /// Register middlewares
    var middlewaresConfig = MiddlewareConfig()
    try middlewares(config: &middlewaresConfig)
    services.register(middlewaresConfig)
    
    var databasesConfig = DatabasesConfig()
    let databaseConfig: PostgreSQLDatabaseConfig

    if let url = Environment.get("DATABASE_URL") {
        databaseConfig = PostgreSQLDatabaseConfig(url: url)!
    } else if let url = Environment.get("DB_POSTGRESQL") {
        databaseConfig = PostgreSQLDatabaseConfig(url: url)!
    } else {
        let hostname = Environment.get("DATABASE_HOSTNAME") ?? "localhost"
        let username = Environment.get("DATABASE_USER") ?? "vapor"
        let password = Environment.get("DATABASE_PASSWORD") ?? "password"
        let databaseName: String
        let databasePort: Int
        if (env == .testing) {
            databaseName = "vapor-test"
            if let testPort = Environment.get("DATABASE_PORT") {
                databasePort = Int(testPort) ?? 5433
            } else {
                databasePort = 5433
            }
        } else {
            databaseName = Environment.get("DATABASE_DB") ?? "vapor"
            databasePort = 5432
        }

        databaseConfig = PostgreSQLDatabaseConfig(
            hostname: hostname,
            port: databasePort,
            username: username,
            database: databaseName,
            password: password)
    }

    let database = PostgreSQLDatabase(config: databaseConfig)

    databasesConfig.add(database: database, as: .psql)

    //try databases(config: &databasesConfig)
    //services.register(databasesConfig)

    services.register { container -> MigrationConfig in
        var migrationConfig = MigrationConfig()
        try migrate(migrations: &migrationConfig)
        return migrationConfig
    }
    
    setupRepositories(services: &services, config: &config)
}
