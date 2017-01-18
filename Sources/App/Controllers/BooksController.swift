//import Vapor
//import HTTP
//import Fluent
//import Routing
//
//final class BooksController: BaseController {
//    
//    override class var resource: String {
//        return "books"
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
//        return JSON(try Book.all().makeNode())
//    }
//    
//    // GET: - /{book_id}
//    func show(request: Request, bookId: String) throws -> ResponseRepresentable {
//        let book = try Author.all().first(where: { (book) -> Bool in
//            return book.id?.string == bookId
//        })
//        guard let lBook = book else { throw Abort.custom(status: Status(statusCode: 404), message: "Book not found") }
//        return lBook
//    }
//
//    // DELETE: - /{book_id}
//    func delete(request: Request, bookId: String) throws -> ResponseRepresentable {
//        guard let book = try Author.all().first(where: { (book) -> Bool in
//            return book.id?.string == bookId
//        }) else { throw Abort.custom(status: Status(statusCode: 404), message: "No such book") }
//        do {
//            try book.delete()
//        } catch let error {
//            print(error)
//        }
//        return JSON([:])
//    }
//}
