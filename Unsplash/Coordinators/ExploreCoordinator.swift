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

extension ExploreCoordinator {
    func setExploreViewController() {
        let exploreViewModel = ExploreViewModel(coordinatorDelegate: self)
        let exploreViewController = ExploreViewController(viewModel: exploreViewModel)
        navigationController.setViewControllers([exploreViewController], animated: false)
    }
    
    func presentPhotoViewController(with photo: Photo) {
        let photoViewModel = PhotoViewModel(coordinatorDelegate: self)
        let photoViewController = PhotoViewController(viewModel: photoViewModel)
        navigationController.present(photoViewController, animated: true)
    }
}

extension ExploreCoordinator: ExploreViewModelDelegate {
    func didSelectPhoto(_ photo: Photo) {
        presentPhotoViewController(with: photo)
    }
}

extension ExploreCoordinator: PhotoViewModelDelegate {
    func didTapDismissButton() {
        navigationController.dismiss(animated: true)
    }
}
