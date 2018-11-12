import UIKit

class AddSingleQueuePopupBuilder {

    private let callback: (String) -> Void
    private var result: UIAlertController?

    init(callback: @escaping (String) -> Void) {
        self.callback = callback
    }

    func build() -> AddSingleQueuePopupBuilder {
        let alertController = UIAlertController(title: "Add new item", message: nil, preferredStyle: .alert)
        let innerCallback = callback

        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            if let text = alertController.textFields?[0].text {
                innerCallback(text)
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alertController.addTextField { $0.keyboardAppearance = .dark }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        alertController.preferredAction = okAction

        result = alertController

        return self
    }

    func getResult() -> UIViewController? {
        return result
    }
}
