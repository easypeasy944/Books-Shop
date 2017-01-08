import Vapor
import Fluent
import Foundation

final class Book: Model {
    
    //MARK: - Attributes
    var id: Node?
    var name: String
    var year: String
    var price: Double
    
    //MARK: -
    var exists: Bool = false

    init(node: Node, in context: Context) throws {
        self.id = try node.extract("id")
        self.name = try node.extract("name")
        self.year = try node.extract("year")
        self.price = try node.extract("price")
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id"    : self.id,
            "name"  : self.name,
            "year"  : self.year,
            "price" : self.price
        ])
    }
    
    func favoritedUsers() throws -> Siblings<User> {
        return try self.siblings()
    }
}

extension Book: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create("books") { (creator) in
            creator.id()
            creator.string("name", length: nil, optional: false, unique: false, default: nil)
            creator.string("year", length: nil, optional: false, unique: false, default: nil)
            creator.double("price")
            creator.parent(Purchase.self, optional: true, unique: true, default: nil)
            creator.parent(Author.self, optional: false, unique: true, default: nil)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("books")
    }
}
