import Foundation

enum NetworkError: Error {
    case internet
    case jsonSerialization
    case jsonDecoder
    case backend(errorResponse: ErrorResponse)
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .internet:
            return "Your internet connection seems to be offline."
        case .jsonSerialization, .jsonDecoder:
            return "There seems to be a parsing error."
        case .backend(let errorResponse):
            return errorResponse.errors.joined(separator: ". ")
        }
    }
}
