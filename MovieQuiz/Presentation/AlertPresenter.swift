import UIKit

class AlertPresenter {
    weak var delegate: UIViewController?
    
    func showResult(viewcontroller: UIViewController, model: AlertModel) {
        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "alert"
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()
        }
        action.accessibilityIdentifier = "alertButton"
        alert.addAction(action)
        viewcontroller.present(alert, animated: true)
        
    }
}
