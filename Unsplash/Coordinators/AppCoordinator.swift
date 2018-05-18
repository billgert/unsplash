import UIKit

class AppCoordinator: Coordinator {
    private let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(window: UIWindow) {
        navigationController = UINavigationController()
        navigationController.view.backgroundColor = .white
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func start() {
        addExploreCoordinator()
    }
}

extension AppCoordinator {
    func addExploreCoordinator() {
        let exploreCoordinator = ExploreCoordinator(navigationController: navigationController)
        addChild(exploreCoordinator)
        exploreCoordinator.start()
    }
}
