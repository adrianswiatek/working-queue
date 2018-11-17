import UIKit

class SingleQueueHeaderLabel: UILabel {
    init(text: String) {
        super.init(frame: .zero)

        self.text = text
        self.textColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        self.backgroundColor = UIColor(white: 0.05, alpha: 1)
        self.textAlignment = .center
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
