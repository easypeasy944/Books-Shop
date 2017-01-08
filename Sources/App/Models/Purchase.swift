import Vapor
import Fluent
import Foundation

final class Purchase: Model {
    
    //MARK: - Attributes
    var id: Node?
    var userId: Node?
    var date: String
    var count: Int
    
    //MARK: - Private variables
    var exists: Bool = false
    
    init(node: Node, in context: Context) throws {
        self.id = try node.extract("id")
        self.userId = try node.extract("users_id")
        self.count = try node.extract("count")
        self.date = try node.extract("date")
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id"      : self.id,
            "users_id": self.userId,
            "date"    : self.date,
            "count"   : self.count
        ])
    }
    
    func purchases() -> Children<Book> {
        return self.children("books", Book.self)
    }
}

extension Purchase: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create("purchases") { (creator) in
            creator.id()
            creator.string("date", length: nil, optional: false, unique: false, default: nil)
            creator.int("count")
            creator.parent(User.self, optional: false, unique: false, default: nil)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("purchases")
    }
}

