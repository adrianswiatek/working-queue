import UIKit

class SingleQueueController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAdd))
    }

    @objc private func handleAdd(button: UIBarButtonItem) {
        guard let controller = AddSingleQueuePopupBuilder().build().getResult() else {
            return
        }

        present(controller, animated: true)
    }
}
