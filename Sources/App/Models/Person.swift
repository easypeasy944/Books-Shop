import Vapor
import Fluent
import Foundation

protocol Person: Preparation {
    
    //MARK: - Attributes
    var id: Node? { get set }
    var name: String? { get set }
    var surname: String? { get set }
    var patronymic: String? { get set }
    
    //MARK: - Private variables
    var exists: Bool { get set }
}
