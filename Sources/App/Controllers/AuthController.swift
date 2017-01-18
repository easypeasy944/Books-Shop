import Vapor
import HTTP
import Fluent
import Foundation
import Routing
import HTTPRouting

final class AuthController: BaseController {
    
    override class var resource: String { return "auth" }
    
    override func addRoutes(routeGroup: Route) {
        let group = routeGroup.grouped(type(of: self).resource)
        group.post("signin", handler: self.signin)
        group.post("login",  handler: self.login)
    }
    
    func signin(request: Request) throws -> ResponseRepresentable {
        
        guard let password = request.data["password"]?.string else { throw Abort.badRequest }
        guard let login = request.data["login"]?.string else { throw Abort.badRequest }
        
        guard var credential = try Credential.query()
                                             .filter("password", password)
                                             .filter("login", login)
                                             .first() else { throw Abort.badRequest }
    
        try Credential.renewToken(credential: &credential)
        try credential.save()
        
        return credential
    }
    
    func login(request: Request) throws -> ResponseRepresentable {
        
        guard let password = request.data["password"]?.string else { throw Abort.badRequest }
        guard let login = request.data["login"]?.string else { throw Abort.badRequest }
        
        let existingCredential = try Credential.query().filter("password", password).filter("login", login).first()
        
        guard existingCredential == nil else { throw Abort.badRequest }
        
        var credential = Credential(password: password, login: login)
        var user = User()
        
        try user.save()
        credential.userId = user.id
        try Credential.renewToken(credential: &credential)
        try credential.save()

        return credential
    }
}
