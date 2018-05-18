import Foundation

struct Photo: Codable {
    let id: String
    let urls: [String: String]
}

extension Photo {
    func urlForType(_ type: PhotoUrlType) -> String? {
        return urls[type.rawValue]
    }
}

enum PhotoUrlType: String {
    case raw = "raw"
    case full = "full"
    case regular = "regular"
    case small = "small"
    case thumb = "thumb"
}

extension Photo {
    static var empty: Photo {
        return Photo(id: "", urls: [:])
    }
}
