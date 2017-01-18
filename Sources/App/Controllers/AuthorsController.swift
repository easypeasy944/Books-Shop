//import Vapor
//import HTTP
//import Fluent
//import Routing
//
//final class AuthorsController: BaseController {
//    
//    override class var resource: String {
//        return "authors"
//    }
//    
//    override func addRoutes(routeGroup: RouteGroup<Responder, Droplet>) {
//        let group = routeGroup.grouped(AuthMiddleware())
//        group.get(handler: self.index)
//        group.get(String.self, handler: self.show)
//        group.delete(String.self, handler: self.delete)
//    }
//    
//    // GET: - /
//    func index(request: Request) throws -> ResponseRepresentable {
//        return JSON(try Author.all().makeNode())
//    }
//    
//    // GET: - /{author_id}
//    func show(request: Request, authorId: String) throws -> ResponseRepresentable {
//        let author = try Author.all().first(where: { (author) -> Bool in
//            return author.id?.string == authorId
//        })
//        guard let lAuthor = author else { throw Abort.custom(status: Status(statusCode: 404), message: "Author not found") }
//        return lAuthor
//    }
//    
//    // DELETE: - /{author_id}
//    func delete(request: Request, userId: String) throws -> ResponseRepresentable {
//        guard let author = try Author.all().first(where: { (author: Author) -> Bool in
//            return author.id?.string == userId
//        }) else { throw Abort.custom(status: Status(statusCode: 404), message: "No such author") }
//        do {
//            try author.delete()
//        } catch let error {
//            print(error)
//        }
//        return JSON([:])
//    }
//}
