import Foundation

protocol PhotoViewModelDelegate: AnyObject {
    func didTapDismissButton()
}

class PhotoViewModel {
    weak var coordinatorDelegate: PhotoViewModelDelegate?
    
    init(coordinatorDelegate: PhotoViewModelDelegate) {
        self.coordinatorDelegate = coordinatorDelegate
    }
}
