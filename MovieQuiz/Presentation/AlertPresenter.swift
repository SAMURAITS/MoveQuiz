import UIKit

class AlertPresenter {
    weak var delegate: AlertPresenterDelegate?
    
    func showResult(viewcontroller: UIViewController, model: AlertModel) {
        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()
        }
        alert.addAction(action)
        viewcontroller.present(alert, animated: true)
        
    }
}
