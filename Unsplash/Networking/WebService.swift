import Alamofire
import RxSwift

class WebService {
    func request<T: Decodable>(router: WebRouter, type: T.Type) -> Observable<T> {
        return Observable.create({ (observer) -> Disposable in
            let request = Alamofire.request(router).responseJSON { response in
                switch response.result {
                case .success(let json):
                    guard let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
                        observer.onError(NetworkError.jsonSerialization)
                        break
                    }
                    if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                        observer.onError(NetworkError.backend(errorResponse: errorResponse))
                        break
                    }
                    guard let model = try? JSONDecoder().decode(type, from: data) else {
                        observer.onError(NetworkError.jsonDecoder)
                        break
                    }
                    observer.onNext(model)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create {
                request.cancel()
            }
        })
    }
}
