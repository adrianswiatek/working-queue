import UIKit

class AddSingleQueuePopupBuilder {

    private var result: UIAlertController?

    func build() -> AddSingleQueuePopupBuilder {
        result = UIAlertController(title: "Add new item", message: nil, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            print("New item added")
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        result?.addTextField { _ in }
        result?.addAction(okAction)
        result?.addAction(cancelAction)
        result?.preferredAction = okAction

        return self
    }

    func getResult() -> UIViewController? {
        return result
    }
}
