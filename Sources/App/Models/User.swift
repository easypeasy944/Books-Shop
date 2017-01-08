import Vapor
import Fluent
import Foundation

final class User: Model, Person {
    
    //MARK: - Attributes
    var id: Node?
    var name: String?
    var surname: String?
    var patronymic: String?
    
    //MARK: - Private variables
    var exists: Bool = false
    
    init(name: String? = nil, surname: String? = nil, patronymic: String? = nil) {
        self.name = name
        self.surname = surname
        self.patronymic = patronymic
    }
    
    required init(node: Node, in context: Context) throws {
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
    
    func favoriteBooks() throws -> Siblings<Book> {
        return try self.siblings()
    }
    
    func purchases() -> Children<Purchase> {
        return self.children("purchases", Purchase.self)
    }

    static func prepare(_ database: Database) throws {
        try database.create("users") { (creator) in
            creator.id()
            creator.string("name", length: nil, optional: true, unique: false, default: nil)
            creator.string("surname", length: nil, optional: true, unique: false, default: nil)
            creator.string("patronymic", length: nil, optional: true, unique: false, default: nil)
            
        }
    }

    static func revert(_ database: Database) throws {
        try database.delete("users")
    }
}
