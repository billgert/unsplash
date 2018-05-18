import UIKit

protocol PhotoViewModelDelegate: AnyObject {
    func didTapDismissButton()
}

class PhotoViewModel {
    let photoId: String
    let image: UIImage
    
    weak var coordinatorDelegate: PhotoViewModelDelegate?
    
    init(coordinatorDelegate: PhotoViewModelDelegate, photoId: String, image: UIImage) {
        self.coordinatorDelegate = coordinatorDelegate
        self.photoId = photoId
        self.image = image
    }
}

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}
