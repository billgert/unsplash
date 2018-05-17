import UIKit
import RxSwift

class ExploreViewController: UIViewController {
    let webService = WebService()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Check for reachability and throw error if neccessary
        webService.request(router: .photos, type: [Photo].self)
            .subscribe { (event) in
                switch event {
                case .next(let photosResponse):
                    print(photosResponse)
                case .completed:
                    print("completed")
                case .error(let error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
}
