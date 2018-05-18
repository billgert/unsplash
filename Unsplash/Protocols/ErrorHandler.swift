import UIKit

protocol ErrorHandler {
    func handleError(_ error: Error)
}

extension ErrorHandler where Self: UIViewController {
    func handleError(_ error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .cancel))
        present(alertController, animated: true)
    }
}

