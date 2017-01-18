import Vapor
import Fluent
import Foundation

final class Credential: Model {
    
    private static let tokenTime: TimeInterval = 86400
    
    //MARK: - Attributes
    var id: Node?
    var password: String
    var login: String
    var expiration_date: String?
    var token: String?
    
    //MARK: - Relationships
    var userId: Node?
    
    //MARK: - Private variables
    var exists: Bool = false
    
    convenience init(node: Node, userId: Node, in context: Context) throws {
        try self.init(node: node, in: context)
        self.userId = userId
    }
    
    init(password: String, login: String) {
        self.password = password
        self.login = login
    }
    
    init(node: Node, in context: Context) throws {
        self.id = try node.extract("id")
        self.password = try node.extract("password")
        self.login = try node.extract("login")
        self.expiration_date = try node.extract("expiration_date")
        self.token = try node.extract("token")
        self.userId = try node.extract("user_id")
    }
    
    func isTokenValid() throws -> Bool {
        guard let date = self.expiration_date, let expirationDate = ISO8601DateFormatter.date(from: date) else { throw Abort.badRequest }
        return Date() < expirationDate
    }
    
    func makeJSON() throws -> JSON {
        let node = try Node(node:
            [
                "token"           : self.token,
                "expiration_date" : self.expiration_date
            ])
        return JSON(node)
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node:
            [
                           "id": self.id,
                     "password": self.password,
                        "login": self.login,
                      "user_id": self.userId,
                        "token": self.token,
              "expiration_date": self.expiration_date
            ])
    }
    
    class func renewToken(credential: inout Credential) throws {
        credential.token = UUID().uuidString
        credential.expiration_date = Date().addingTimeInterval(Credential.tokenTime).ISO8601FormatString
    }
}

extension Credential: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create("credentials") { (creator) in
            creator.id()
            creator.string("password", length: nil, optional: false, unique: true, default: nil)
            creator.string("login", length: nil, optional: false, unique: true, default: nil)
            creator.string("token", length: nil, optional: true, unique: false, default: nil)
            creator.string("expiration_date", length: nil, optional: true, unique: false, default: nil)
            creator.parent(User.self, optional: false, unique: true, default: nil)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("credentials")
    }
}
