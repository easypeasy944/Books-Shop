import Vapor
import HTTP
import Fluent

class BaseController {

    func addRoutes(drop: Droplet) {
    }
    
    func addPreparations(drop: Droplet) {
    }
    
    init(drop: Droplet) {
        self.addRoutes(drop: drop)
        self.addPreparations(drop: drop)
    }
    
}
