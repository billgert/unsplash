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
    
    func didSelectPhoto(_ photo: Photo, image: UIImage) {
        presentPhotoViewController(photo, image: image)
    }
}

extension ExploreCoordinator: PhotoViewModelDelegate {
    func presentPhotoViewController(_ photo: Photo, image: UIImage) {
        let photoViewModel = PhotoViewModel(coordinatorDelegate: self, photoId: photo.id, image: image)
        let photoViewController = PhotoViewController(viewModel: photoViewModel)
        navigationController.present(photoViewController, animated: true)
    }
    
    func didTapDismissButton() {
        navigationController.dismiss(animated: true)
    }
}
