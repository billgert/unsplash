import UIKit
import Hero

class PhotoViewController: UIViewController, ErrorHandler {
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer()
        gesture.addTarget(self, action: #selector(handlePan(gestureRecognizer:)))
        return gesture
    }()
    
    let viewModel: PhotoViewModel
    
    init(viewModel: PhotoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupTransition()
        setupImage()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        view.addGestureRecognizer(panGestureRecognizer)
        
        view.addSubview(imageView, constraints: [
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc func handlePan(gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            dismiss(animated: true, completion: nil)
        case .changed:
            let translation = gestureRecognizer.translation(in: nil)
            let progress = translation.y / 2 / view.bounds.height
            Hero.shared.update(progress)
            Hero.shared.apply(modifiers: [.position(translation + imageView.center)], to: imageView)
        default:
            Hero.shared.finish()
        }
    }
    
    private func setupTransition() {
        modalPresentationStyle = .overFullScreen
        hero.isEnabled = true
        hero.modalAnimationType = .zoom
    }
    
    private func setupImage() {
        imageView.hero.id = viewModel.photoId
        imageView.image = viewModel.image
    }
}
