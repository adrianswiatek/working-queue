import UIKit

public protocol FinishedItemsControllerDelegate {
    func entryDidDelete(viewController: FinishedItemsController, entry: WorkflowEndEntry)
}

public class FinishedItemsController: UITableViewController {

    public var entry: WorkflowEndEntry?
    public var delegate: FinishedItemsControllerDelegate?

    private let cellIdentifier = "Cell"

    public override func viewDidLoad() {
        configureTableView()
    }

    private func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entry?.numberOfEntries ?? 0
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = entry?.getEntries()[indexPath.row].name
        return cell
    }

    public override func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, sourceView, completionHandler) in
            guard let `self` = self, let entry = self.entry else {
                completionHandler(false)
                return
            }

            let entryToRemove = entry.getEntries()[indexPath.row]
            entry.removeEntry(entryToRemove)

            self.entry = entry
            self.delegate?.entryDidDelete(viewController: self, entry: entry)

            completionHandler(true)
            self.tableView.reloadData()
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
