import UIKit
import Toast_Swift

public extension UIViewController {
    func makeToast(_ message: String) {
        let point = CGPoint(x: view.frame.width / 2, y: view.frame.height - 124)
        view.makeToast(message, point: point, title: nil, image: nil, completion: nil)
    }
}
