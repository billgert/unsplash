import UIKit
import AlamofireImage
import Hero

class PhotoViewController: UIViewController, ErrorHandler {
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    let viewModel: PhotoViewModel
    
    init(viewModel: PhotoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        hero.isEnabled = true
        hero.modalAnimationType = .zoom
        loadImage()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        view.addSubview(imageView, constraints: [
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func loadImage() {
        guard let imageUrl = viewModel.photo.urlForType(.regular) else { return }
        guard let url = URL(string: imageUrl) else { return }
        imageView.hero.id = viewModel.photo.id
        imageView.af_setImage(withURL: url)
    }
}
