import Vapor
import Fluent

final class Credential: Model {
    
    //MARK: - Attributes
    var id: Node?
    var password: String
    var login: String
    
    //MARK: - Relationships
    var userId: Node?
    
    //MARK: - Private variables
    var exists: Bool = false
    
    init(password: String, login: String) {
        self.password = password
        self.login = login
    }
    
    init(node: Node, userId: Node, in context: Context) throws {
        self.password = try node.extract("password")
        self.login = try node.extract("login")
        self.userId = userId
    }
    
    init(node: Node, in context: Context) throws {
        self.id = try node.extract("id")
        self.password = try node.extract("password")
        self.login = try node.extract("login")
        self.userId = try node.extract("user_id")
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id"      : self.id,
            "login"   : self.login,
            "password": self.password,
            "user_id": self.userId
        ])
    }
}

extension Credential: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create("credentials") { (creator) in
            creator.id()
            creator.string("password", length: nil, optional: false, unique: true, default: nil)
            creator.string("login", length: nil, optional: false, unique: true, default: nil)
            creator.parent(User.self, optional: false, unique: true, default: nil)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("credentials")
    }
}
