import Vapor
import VaporPostgreSQL
import Fluent

let drop = Droplet()
try drop.addProvider(VaporPostgreSQL.Provider.self)

drop.preparations += Book.self
drop.preparations += Purchase.self
drop.preparations += Author.self
drop.preparations += Credential.self

let usersController = UserController(drop: drop)
let authController = AuthController(drop: drop)

drop.run()
