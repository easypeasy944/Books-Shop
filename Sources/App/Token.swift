import Vapor
import Fluent
import Foundation
import HTTP

final class Token: ResponseRepresentable {
    
    private static let tokenTime: TimeInterval = 86400
    var token: String = UUID().uuidString
    var expirationDate: Date = Date().addingTimeInterval(tokenTime)
    
    init() { }
    
    func makeResponse() throws -> Response {
        let node = try Node(node: ["token"           : self.token,
                                   "expiration_date" : self.expirationDate.ISO8601FormatString])
        return try Response(status: Status(statusCode: 200), json: JSON(node))
    }
}
