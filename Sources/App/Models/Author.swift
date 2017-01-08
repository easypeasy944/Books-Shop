import Vapor
import Fluent
import Foundation

final class Author: Model, Person {
    
    //MARK: - Attributes
    var id: Node?
    var name: String?
    var surname: String?
    var patronymic: String?
    
    //MARK: - Private variables
    var exists: Bool = false
    
    init(node: Node, in context: Context) throws {
        self.id = try node.extract("id")
        self.name = try node.extract("name")
        self.surname = try node.extract("surname")
        self.patronymic = try node.extract("patronymic")
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id"         : self.id,
            "name"       : self.name,
            "surname"    : self.surname,
            "patronymic" : self.patronymic
            ])
    }
    
    func books() -> Children<Book> {
        return self.children("books", Book.self)
    }

    static func prepare(_ database: Database) throws {
        try database.create("authors") { (creator) in
            creator.id()
            creator.string("name", length: nil, optional: false, unique: false, default: nil)
            creator.string("surname", length: nil, optional: false, unique: false, default: nil)
            creator.string("patronymic", length: nil, optional: false, unique: false, default: nil)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("authors")
    }
}

