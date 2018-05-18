import UIKit

class ExploreCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    private var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        setExploreViewController()
    }
}

extension ExploreCoordinator: ExploreViewModelDelegate {
    func setExploreViewController() {
        let exploreViewModel = ExploreViewModel(coordinatorDelegate: self)
        let exploreViewController = ExploreViewController(viewModel: exploreViewModel)
        navigationController.setViewControllers([exploreViewController], animated: false)
    }
    
    func didSelectPhoto(_ photo: Photo) {
        print(photo.id)
    }
}

extension ExploreCoordinator: PhotoViewModelDelegate {
    func presentPhotoViewController(with photo: Photo) {
        let photoViewModel = PhotoViewModel(coordinatorDelegate: self)
        let photoViewController = PhotoViewController(viewModel: photoViewModel)
        navigationController.present(photoViewController, animated: true)
    }
    
    func didTapDismissButton() {
        navigationController.dismiss(animated: true)
    }
}
