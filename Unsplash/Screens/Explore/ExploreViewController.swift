import RxSwift
import RxCocoa

class ExplorePhotoCell: UICollectionViewCell {
    var item: ExplorePhotoItem?
}

struct ExplorePhotoItem {
    var photo: Photo
}

class ExploreViewController: UIViewController, ErrorHandler {
    let searchBar = UISearchBar()
    let collectionView = UICollectionView()
    
    let disposeBag = DisposeBag()
    let viewModel: ExploreViewModel
    
    init(viewModel: ExploreViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    func setupBindings() {
        viewModel.error.asObservable()
            .subscribe(onNext: { [weak self] (error) in
                self?.handleError(error)
            })
            .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .throttle(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: viewModel.textInput)
            .disposed(by: disposeBag)
        
        viewModel.results.asObservable()
            .bind(to: collectionView.rx.items(
                cellIdentifier: "ExplorePhotoCell",
                cellType: ExplorePhotoCell.self)) { (index, photoItem: ExplorePhotoItem, cell) in
                    cell.item = photoItem
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(ExplorePhotoItem.self)
            .subscribe(onNext: { [unowned self] (photoItem) in
                self.viewModel.coordinatorDelegate?.didSelectPhoto(photoItem.photo)
            })
            .disposed(by: disposeBag)
    }
}
