import UIKit

class SingleQueueHeaderLabel: UILabel {
    init(text: String) {
        super.init(frame: .zero)

        self.text = text
        self.textColor = .tintColor
        self.backgroundColor = .accentColor
        self.textAlignment = .center
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
