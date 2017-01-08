import Vapor
import HTTP
import Fluent
import Foundation

final class AuthController: BaseController {

    override func addRoutes(drop: Droplet) {
        let basic = drop.grouped("auth")
        basic.post("signin", handler: self.signin)
        basic.post("login", handler: self.login)
    }
    
    func signin(request: Request) throws -> ResponseRepresentable {
        
        guard let password = request.data["password"]?.string else { throw Abort.badRequest }
        guard let login = request.data["login"]?.string else { throw Abort.badRequest }
        
        guard let _ = try Credential.query().filter("password", password).filter("login", login).first() else { throw Abort.badRequest }
        return try Token().makeResponse()
    }
    
    func login(request: Request) throws -> ResponseRepresentable {
        
        guard let password = request.data["password"]?.string else { throw Abort.badRequest }
        guard let login = request.data["login"]?.string else { throw Abort.badRequest }
        
        let existingCredential = try Credential.query().filter("password", password).filter("login", login).first()
        
        guard existingCredential == nil else { throw NSError(domain: "server", code: 100, userInfo: ["desc" : "some"]) }
        
        var credential = Credential(password: password, login: login)
        var user = User()
        
        try user.save()
        credential.userId = user.id
        try credential.save()
        
        return try Token().makeResponse()
    }
    
    override func addPreparations(drop: Droplet) {
        
    }
    
    override init(drop: Droplet) {
        super.init(drop: drop)
    }
}
