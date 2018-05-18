import UIKit
import RxSwift

class PhotoViewController: UIViewController, ErrorHandler {
    let viewModel: PhotoViewModel
    
    init(viewModel: PhotoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
