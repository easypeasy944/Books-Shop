import Vapor
import HTTP
import Fluent
import Routing

final class UserController: BaseController {
    
    override class var resource: String {
        return "users"
    }
    
    override func addRoutes(routeGroup: Route) {
        let group = routeGroup.grouped(type(of: self).resource).grouped(AuthMiddleware())
        group.get(handler: self.index)
        group.get(String.self, handler: self.show)
        group.delete(String.self, handler: self.delete)
    }
    
    // GET: - /
    func index(request: Request) throws -> ResponseRepresentable {
        return JSON(try User.all().makeNode())
    }
    
    // GET: - /{user_id}
    func show(request: Request, userId: String) throws -> ResponseRepresentable {
        let users = try? User.all()
        guard let userById = users?.filter({ $0.id?.string == userId }).first else {
            throw Abort.custom(status: Status(statusCode: 404), message: "No such user")
        }
        guard let userNode = try? userById.makeJSON() else {
            throw Abort.custom(status: Status(statusCode: 500), message: "User serialization failed")
        }
        return userNode
    }
    
    // DELETE: - /{user_id}
    func delete(request: Request, userId: String) throws -> ResponseRepresentable {
        guard let user = try User.all().first(where: { (user: User) -> Bool in
            return user.id?.string == userId
        }) else { throw Abort.custom(status: Status(statusCode: 404), message: "No such user") }
        do {
            try user.credential()?.delete()
            try user.purchases().all().forEach { try $0.delete() }
            try user.delete()
        } catch let error {
            print(error)
        }
        return JSON([:])
    }

    // PATCH: - /{user_id}
    func update(request: Request, user: User) throws -> ResponseRepresentable {
        var user = try request.user()
        try user.save()
        return user
    }

    // PUT: - /{user_id}
    func replace(request: Request, user: User) throws -> ResponseRepresentable {
        try user.delete()
        var newUser = try request.user()
        try newUser.save()
        return newUser
    }
}

extension Request {
    func user() throws -> User {
        guard let json = json else { throw Abort.badRequest }
        return try User(node: json)
    }
}
