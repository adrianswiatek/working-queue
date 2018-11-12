import UIKit

class ControlBar: UIView {

    var delegate: ControlBarDelegate?

    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "add"), for: .normal)
        button.tintColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)
        return button
    }()

    init() {
        super.init(frame: .zero)

        backgroundColor = UIColor(white: 0.05, alpha: 1)
        translatesAutoresizingMaskIntoConstraints = false

        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setupViews() {
        addSubview(addButton)

        NSLayoutConstraint.activate([
            addButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            addButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    @objc private func handleAdd(button: UIButton) {
        delegate?.controlBarDidAdd(self)
    }
}
