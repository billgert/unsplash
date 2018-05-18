import UIKit

extension UIView {
    func addSubview(_ child: UIView, constraints: [NSLayoutConstraint]) {
        addSubview(child)
        child.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints.map { $0 })
    }
}
