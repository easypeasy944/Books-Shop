import Vapor
import HTTP

final class AuthMiddleware: Middleware  {

    func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        
        guard let token = request.headers[HeaderKey.authorization] else { throw Abort.badRequest }
        guard let validToken = try Credential.all().first(where: { $0.token == token }) else { throw Abort.custom(status: Status.unauthorized, message: "Token is not valid") }
        guard try validToken.isTokenValid() else { throw Abort.custom(status: Status.unauthorized, message: "Token has expired") }

        return try next.respond(to: request)
    }
}
