import UIKit

class ControlBar: UIView {

    init() {
        super.init(frame: .zero)
        backgroundColor = UIColor(white: 0.05, alpha: 1)
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
