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
        view.dataSource = self
        view.delegate = self
        view.keyboardDismissMode = .interactive
        view.backgroundColor = .clear
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
        
        viewModel.photos.asObservable()
            .bind(onNext: { [weak self] _ in
                self?.collectionView.collectionViewLayout.invalidateLayout()
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension ExploreViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExplorePhotoCell", for: indexPath) as! ExplorePhotoCell
        cell.photo = viewModel.photos.value[indexPath.item]
        return cell
    }
}

extension ExploreViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = viewModel.photos.value[indexPath.item]
        viewModel.coordinatorDelegate?.didSelectPhoto(photo)
    }
}
