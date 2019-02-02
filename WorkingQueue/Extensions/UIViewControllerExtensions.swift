import UIKit
import Toast_Swift

public extension UIViewController {
    func makeToast(_ message: String) {
        func getPoint() -> CGPoint {
            let width = view.frame.width
            let height = view.frame.height
            return CGPoint(x: width / 2, y: height - height / 5)
        }
        view.makeToast(message, point: getPoint(), title: nil, image: nil, completion: nil)
    }
}
