import UIKit

class AppCoordinator: Coordinator {
    private let viewController: UIViewController
    var childCoordinators: [Coordinator] = []
    
    init(window: UIWindow) {
        viewController = UIViewController()
        viewController.view.backgroundColor = .white
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
    
    func start() {
        addExploreCoordinator()
    }
    
}

extension AppCoordinator {
    
    func addExploreCoordinator() {
        let exploreCoordinator = ExploreCoordinator(viewController: viewController)
        addChild(exploreCoordinator)
        exploreCoordinator.start()
    }
    
}
