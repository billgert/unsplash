import Alamofire
import RxSwift

class WebService {
    func request<T: Decodable>(router: WebRouter, type: T.Type) -> Observable<T> {
        return Observable.create({ (observer) -> Disposable in
            let request = Alamofire.request(router).responseJSON { response in
                switch response.result {
                case .success(let json):
                    guard let jsonString = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
                        observer.onError(NetworkError.jsonSerialization)
                        break
                    }
                    guard let decoded = try? JSONDecoder().decode(type, from: jsonString) else {
                        observer.onError(NetworkError.jsonDecoder)
                        break
                    }
                    observer.onNext(decoded)
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
