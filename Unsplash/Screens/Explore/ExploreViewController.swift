import UIKit
import RxSwift

class ExploreViewController: UIViewController, ErrorHandler {
    let webService = WebService()
    let disposeBag = DisposeBag()
    let viewModel: ExploreViewModel
    
    init(viewModel: ExploreViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Check for reachability and throw error if neccessary
        webService.request(router: .photos, type: [Photo].self)
            .subscribe { [weak self] (event) in
                switch event {
                case .next(let photosResponse):
                    print(photosResponse)
                case .completed:
                    print("completed")
                case .error(let error):
                    self?.handleError(error)
                }
            }
            .disposed(by: disposeBag)
    }
}
