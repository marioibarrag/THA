import UIKit

extension UIViewController {
    
    func presentAlertInMainThread(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Oops...", message: message, preferredStyle: .alert)
            let button = UIAlertAction(title: "OK", style: .default)
            alert.addAction(button)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
