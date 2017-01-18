import Foundation

let ISO8601DateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    return dateFormatter
}()

extension Date {
    
    var ISO8601FormatString: String {
        return ISO8601DateFormatter.string(from: self)
    }
}
