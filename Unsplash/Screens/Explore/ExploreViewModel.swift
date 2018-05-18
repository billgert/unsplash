import RxSwift

protocol ExploreViewModelDelegate: AnyObject {
    func didSelectPhoto(_ photo: Photo)
}

class ExploreViewModel {
    let error = Variable<Error>(NetworkError.internet)
    let textInput = Variable<String>("")
    let results = Variable<[ExplorePhotoItem]>([])
    
    let disposeBag = DisposeBag()
    let webService = WebService()
    
    weak var coordinatorDelegate: ExploreViewModelDelegate?
    
    init(coordinatorDelegate: ExploreViewModelDelegate) {
        self.coordinatorDelegate = coordinatorDelegate
        getAllPhotos()
        bindTextInput()
    }
}

extension ExploreViewModel {
    private func getAllPhotos() {
        webService.request(router: .photos, type: [Photo].self)
            .map({ (photos) -> [ExplorePhotoItem] in
                return photos.map({ (photo) -> ExplorePhotoItem in
                    return ExplorePhotoItem(photo: photo)
                })
            })
            .subscribe({ [weak self] (event) in
                switch event {
                case .next(let photoItems):
                    self?.results.value = photoItems
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
                self.webService.request(router: .searchPhotos(query: text), type: SearchResponse.self)
            })
            .map({ (response) -> [ExplorePhotoItem] in
                response.results.map({ (photo) -> ExplorePhotoItem in
                    ExplorePhotoItem(photo: photo)
                })
            })
            .subscribe({ [weak self] (event) in
                switch event {
                case .next(let photoItems):
                    self?.results.value = photoItems
                case .completed:
                    print("completed: textInput")
                case .error(let error):
                    self?.error.value = error
                }
            })
            .disposed(by: disposeBag)
    }
}
