import UIKit

class DequeuePopupButton: UIButton {

    convenience init(title: String, isPrimaryAction: Bool = false) {
        self.init(type: .system)

        setTitle(title, for: .normal)
        titleLabel?.font = getFont(isPrimaryAction)

        tintColor = .tintColor
        backgroundColor = .accentColor

        layer.cornerRadius = 20

        layer.borderColor = UIColor.accentColor.cgColor
        layer.borderWidth = 1

        translatesAutoresizingMaskIntoConstraints = false
    }

    private func getFont(_ isPrimaryAction: Bool) -> UIFont {
        return isPrimaryAction ? .boldSystemFont(ofSize: 16) : .systemFont(ofSize: 16)
    }
}
