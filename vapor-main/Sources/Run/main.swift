import Vapor
import Foundation
import App

@main
struct Run {
    static func main() async throws {
        var env = try Environment.detect()
        try LoggingSystem.bootstrap(from: &env)

        let app = try await Application.make(env)
        defer { app.shutdown() }
        try await configure(app)

        try await app.execute()
    }
}
