import Alamofire
import RxSwift

class WebService {
    func request<T: Decodable>(router: WebRouter, type: T.Type) -> Observable<T> {
        return Observable.create({ (observer) -> Disposable in
            let request = Alamofire.request(router).responseJSON { response in
                switch response.result {
                case .success(let json):
                    let jsonString = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                    let decoded = try! JSONDecoder().decode(type, from: jsonString)
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
