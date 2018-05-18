import RxSwift

protocol ExploreViewModelDelegate: AnyObject {
    func didSelectPhoto(_ photo: Photo)
}

class ExploreViewModel {
    let error = Variable<Error>(NetworkError.internet)
    let textInput = Variable<String>("")
    let results = Variable<[Photo]>([])
    
    let disposeBag = DisposeBag()
    let webService = WebService()
    
    weak var coordinatorDelegate: ExploreViewModelDelegate?
    
    init(coordinatorDelegate: ExploreViewModelDelegate) {
        self.coordinatorDelegate = coordinatorDelegate
        bindTextInput()
    }
}

extension ExploreViewModel {
    func getPhotos() {
        webService.request(router: .photos(perPage: 50), type: [Photo].self)
            .subscribe({ [weak self] (event) in
                switch event {
                case .next(let photos):
                    self?.results.value = photos
                case .completed:
                    print("completed: photos")
                case .error(let error):
                    self?.error.value = error
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindTextInput() {
        textInput.asObservable()
            .flatMap({ [unowned self] (text) -> Observable<SearchResponse> in
                self.webService.request(router: .searchPhotos(query: text, perPage: 50), type: SearchResponse.self)
            })
            .subscribe({ [weak self] (event) in
                switch event {
                case .next(let response):
                    self?.results.value = response.results
                case .completed:
                    print("completed: textInput")
                case .error(let error):
                    self?.error.value = error
                }
            })
            .disposed(by: disposeBag)
    }
}
