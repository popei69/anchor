import Leaf
import Vapor

/// Called before your application initializes.
public func configure(_ app: Application) throws {

    // Serves files from `Public/` directory
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // Configure Leaf
    app.views.use(.leaf)
    app.leaf.cache.isEnabled = app.environment.isRelease

    // Configure SQLite database
//    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)

    // Configure migrations
//    app.migrations.add(CreateTodo())

    try routes(app)
}
