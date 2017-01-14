import Vapor
import HTTP
import Fluent

final class UserController: BaseController {
    
    override func addRoutes(drop: Droplet) {
        let basic = drop.grouped("users")
        basic.get(handler: self.index)
        basic.post(handler: self.create)
        basic.get(String.self, handler: self.show)
    }
    
    override func addPreparations(drop: Droplet) {
        drop.preparations += User.self
        drop.preparations += Pivot<User, Book>.self
    }
    
    override init(drop: Droplet) {
        super.init(drop: drop)
    }
    
    func handleSocket(request: Request, socket: WebSocket) throws -> Void {
        
        socket.onClose = { (ws: WebSocket, code: UInt16?, reason: String?, clean: Bool) -> Void in
            
        }
        
        socket.onText = { (ws: WebSocket, text: String) -> Void in
            print(text)
        }
    }
    
    // GET: - /
    func index(request: Request) throws -> ResponseRepresentable {
        return try User.all().makeNode().converted(to: JSON.self)
    }

    // POST: - /
    func create(request: Request) throws -> ResponseRepresentable {
        var post = try request.user()
        try post.save()
        return post
    }

    // GET: - /{user_id}
    func show(request: Request, book: User) throws -> ResponseRepresentable {
        throw JSONError.allowFragmentsNotSupported
    }
    
    // GET: - /{user_id}
    func show(request: Request, userId: String) throws -> ResponseRepresentable {
        throw JSONError.allowFragmentsNotSupported
    }
    
    // DELETE: - /{user_id}
    func delete(request: Request, user: User) throws -> ResponseRepresentable {
        try user.delete()
        return JSON([:])
    }

    // DELETE: - /
    func clear(request: Request) throws -> ResponseRepresentable {
        try User.query().delete()
        return JSON([])
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
        return try create(request: request)
    }
}

extension Request {
    func user() throws -> User {
        guard let json = json else { throw Abort.badRequest }
        return try User(node: json)
    }
}
