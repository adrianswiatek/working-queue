import UIKit

class SingleQueueController: UITableViewController {

    private let cellIdentifier = "QueueCell"
    private var queue = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
    }

    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.tableFooterView = UIView()
    }

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAdd))
    }

    @objc private func handleAdd(button: UIBarButtonItem) {
        let popupController = AddSingleQueuePopupBuilder(callback: { [unowned self] in self.itemDidAdd($0) })

        if let controller = popupController.build().getResult() {
            present(controller, animated: true)
        }
    }

    private func itemDidAdd(_ name: String) {
        queue.append(name)
        tableView.insertRows(at: [IndexPath(row: queue.count - 1, section: 0)], with: .automatic)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return queue.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = queue[indexPath.row]
        return cell
    }
}
