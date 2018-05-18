import RxSwift

protocol ExploreViewModelDelegate: AnyObject {
    func didSelectPhoto(_ photo: Photo, image: UIImage)
}

class ExploreViewModel {
    let error = Variable<Error>(NetworkError.internet)
    let textInput = Variable<String>("")
    let photos = Variable<[Photo]>([])
    let willShowKeyboard = Variable<CGFloat>(0.0)
    let willHidekeyboard = Variable<Bool>(true)
    
    let disposeBag = DisposeBag()
    let webService = WebService()
    
    weak var coordinatorDelegate: ExploreViewModelDelegate?
    
    init(coordinatorDelegate: ExploreViewModelDelegate) {
        self.coordinatorDelegate = coordinatorDelegate
        bindTextInput()
        addKeyboardObservers()
    }
}

extension ExploreViewModel {
    func getPhotos() {
        webService.request(router: .photos(perPage: 20), type: [Photo].self)
            .subscribe({ [weak self] (event) in
                switch event {
                case .next(let photos):
                    self?.photos.value = photos
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
                self.webService.request(router: .searchPhotos(query: text, perPage: 20), type: SearchResponse.self)
            })
            .subscribe({ [weak self] (event) in
                switch event {
                case .next(let response):
                    self?.photos.value = response.results
                case .completed:
                    print("completed: textInput")
                case .error(let error):
                    self?.error.value = error
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        willShowKeyboard.value = keyboardHeight
    }
    
    @objc func keyboardWillHide() {
        willHidekeyboard.value = true
    }
}
