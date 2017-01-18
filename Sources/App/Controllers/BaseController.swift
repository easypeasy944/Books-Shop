import Vapor
import HTTP
import Fluent
import Routing
import Foundation

typealias Route = RouteGroup<Responder, Droplet>

class BaseController: ResourceHolding {
    
    class var resource: String { return "" }
    
    func addRoutes(routeGroup: Route) {
        fatalError("Should be overriden")
    }
    
    init(routeGroup: Route) {
        self.addRoutes(routeGroup: routeGroup)
    }
}

protocol ResourceHolding: class {
    static var resource: String { get }
}
