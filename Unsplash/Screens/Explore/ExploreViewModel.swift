import Foundation

protocol ExploreViewModelDelegate: AnyObject {
    func didSelectPhoto(_ photo: Photo)
}

class ExploreViewModel {
    weak var coordinatorDelegate: ExploreViewModelDelegate?
    
    init(coordinatorDelegate: ExploreViewModelDelegate) {
        self.coordinatorDelegate = coordinatorDelegate
    }
}
