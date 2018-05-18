import RxSwift
import RxCocoa

class ExploreViewController: UIViewController, ErrorHandler {
    lazy var searchBar: UISearchBar = {
        let view = UISearchBar()
        view.placeholder = "Search photos"
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: ExploreCollectionLayout())
        view.register(ExplorePhotoCell.self, forCellWithReuseIdentifier: "ExplorePhotoCell")
        view.backgroundColor = .clear
        view.keyboardDismissMode = .interactive
        view.contentInset = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        return view
    }()
    
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
        
        navigationItem.titleView = searchBar
        
        view.addSubview(collectionView, constraints: [
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        setupBindings()
        viewModel.getPhotos()
    }
    
    private func setupBindings() {
        viewModel.error.asObservable()
            .skip(1)
            .subscribe(onNext: { [weak self] (error) in
                self?.handleError(error)
            })
            .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: viewModel.textInput)
            .disposed(by: disposeBag)
        
        viewModel.results.asObservable()
            .bind(to: collectionView.rx.items(
                cellIdentifier: "ExplorePhotoCell",
                cellType: ExplorePhotoCell.self)) { (index, photo: Photo, cell) in
                    cell.photo = photo
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(Photo.self)
            .subscribe(onNext: { [unowned self] (photo) in
                self.viewModel.coordinatorDelegate?.didSelectPhoto(photo)
            })
            .disposed(by: disposeBag)
    }
}
