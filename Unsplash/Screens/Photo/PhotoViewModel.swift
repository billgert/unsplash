import Foundation

protocol PhotoViewModelDelegate: AnyObject {
    func didTapDismissButton()
}

class PhotoViewModel {
    let photo: Photo
    
    weak var coordinatorDelegate: PhotoViewModelDelegate?
    
    init(coordinatorDelegate: PhotoViewModelDelegate, photo: Photo) {
        self.coordinatorDelegate = coordinatorDelegate
        self.photo = photo
    }
}
