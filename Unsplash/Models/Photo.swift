import Foundation

struct Photo: Codable {
    let id: String
    let urls: [String: String]
}
