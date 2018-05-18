import Alamofire

enum WebRouter {
    case photos(perPage: Int)
    case searchPhotos(query: String, perPage: Int)
}

extension WebRouter: URLRequestConvertible {
    var method: HTTPMethod {
        switch self {
        case .photos, .searchPhotos:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .photos:
            return "photos"
        case .searchPhotos:
            return "search/photos"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .photos(let perPage):
            return ["per_page": perPage]
        case .searchPhotos(let query, let perPage):
            return ["query": query, "per_page": perPage]
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = try NetworkConstants.baseUrl.asURL()
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.setValue(NetworkConstants.authenticationToken, forHTTPHeaderField: "Authorization")
        request.timeoutInterval = TimeInterval(10 * 1000)
        return try URLEncoding.default.encode(request, with: parameters)
    }
}
