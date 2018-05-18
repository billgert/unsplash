import UIKit

class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    private let navigationController: UINavigationController
    
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
