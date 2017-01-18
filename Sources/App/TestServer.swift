import Vapor
import VaporPostgreSQL
import Fluent
import HTTP
import Routing
import HTTPRouting

final class TestServer {

    enum Config {
        
        static var version: Int = 1
        static var apiPrefix: String = "api"
        
        static var apiVersionPrefix: String {
            return "\(Config.apiPrefix)/v\(Config.version)"
        }
    }
    
    static var shared: TestServer = TestServer()
    
    //MARK: - Private variables
    final private var droplet: Droplet
    
    //MARK: - Controllers
    final private var usersController: UserController!
    final private var authController : AuthController!
    
    //MARK: - Middlewares
    final private var authMiddleware   : AuthMiddleware!
    final private var versionMiddleware: VersionMiddleware!
    
    init() {
        self.droplet = Droplet()

        switch self.droplet.environment {
            case .production:
                print("Running on production environment")
            case .development:
                print("Running on development environment")
            case .test:
                print("Running on test environment")
            default:
                print("Running on unknown environment")
        }
        
        self.setupMiddlewares()
        try! self.setupProviders()
        self.setupControllers()
        self.setupDatabase()
        self.setupSockets()
    }
    
    //MARK: - Basic setup
    private func setupProviders() throws {
        try self.droplet.addProvider(VaporPostgreSQL.Provider.self)
    }
    
    private func setupDatabase() {
        self.droplet.preparations += Book.self
        self.droplet.preparations += Purchase.self
        self.droplet.preparations += Author.self
        self.droplet.preparations += Credential.self
        self.droplet.preparations += User.self
        self.droplet.preparations += Pivot<User, Book>.self
    }
    
    private func setupControllers() {
        let group: RouteGroup<Responder, Droplet> = self.droplet.grouped(Config.apiVersionPrefix)
        self.usersController = UserController(routeGroup: group)
        self.authController  = AuthController(routeGroup: group)
    }
    
    private func setupMiddlewares() {
        self.versionMiddleware = VersionMiddleware()
        self.droplet.middleware += self.versionMiddleware
    }
    
    private func setupSockets() {
        
        self.droplet.socket("socket") { (request, socket) in
            
            socket.onText = { socket, text in
                try socket.send("Response from server: \(text)")
                self.droplet.console.print("Socket received data: \(text)")
            }
            
            socket.onClose = { socket, code, reason, clean in
                self.droplet.console.print("Socket closed. Code - \(code), reason - \(reason), clean - \(clean)")
            }
        }
    }
    
    func run() {
        self.droplet.run()
    }
}
