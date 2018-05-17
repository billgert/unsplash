import Foundation

struct SearchPhotosResponse: Codable {
    let total: Int
    let totalPages: Int
    let results: [Photo]
}
