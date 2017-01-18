import Vapor
import HTTP

final class VersionMiddleware: Middleware {

    func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        guard request.isValidVersion() else { throw Abort.badRequest }
        return try next.respond(to: request)
    }
}

