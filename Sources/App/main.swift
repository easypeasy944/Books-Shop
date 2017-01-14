import Vapor
import VaporPostgreSQL
import Fluent
import Foundation

let drop = Droplet()
try drop.addProvider(VaporPostgreSQL.Provider.self)

drop.preparations += Book.self
drop.preparations += Purchase.self
drop.preparations += Author.self
drop.preparations += Credential.self

drop.socket("socket") { (request, socket) in
    
    socket.onText = { socket, text in
        try socket.send("Response from server: \(text)")
        drop.console.print("Socket received data: \(text)")
    }
    
    socket.onClose = { socket, code, reason, clean in
        drop.console.print("Socket closed. Code - \(code), reason - \(reason), clean - \(clean)")
    }
}


let usersController = UserController(drop: drop)
let authController = AuthController(drop: drop)


drop.run()
