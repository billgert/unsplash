import RxSwift

protocol ExploreViewModelDelegate: AnyObject {
    func didSelectPhoto(_ photo: Photo)
}

class ExploreViewModel {
    let webService = WebService()
    let disposeBag = DisposeBag()
    
    weak var coordinatorDelegate: ExploreViewModelDelegate?
    
    init(coordinatorDelegate: ExploreViewModelDelegate) {
        self.coordinatorDelegate = coordinatorDelegate
        
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
