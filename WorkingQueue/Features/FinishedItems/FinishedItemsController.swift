import UIKit

public protocol FinishedItemsControllerDelegate {
    func didDelete(viewController: FinishedItemsController)
}

public class FinishedItemsController: UIViewController {

    public var entry: WorkflowEndEntry?
    public var delegate: FinishedItemsControllerDelegate?

    private let cellIdentifier = "Cell"

    private let toolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.barTintColor = .accentColor
        toolbar.tintColor = .tintColor
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        return toolbar
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .backgroundColor
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    public override func viewDidLoad() {
        configureTableView()
        configureToolbar()
        setupViews()
    }

    private func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.allowsSelection = false
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func configureToolbar() {
        let spaceBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil)

        let deleteAllBarButtonItem = UIBarButtonItem(
            title: "Delete All",
            style: .plain,
            target: self,
            action: #selector(deleteAll))

        toolbar.setItems([spaceBarButtonItem, deleteAllBarButtonItem, spaceBarButtonItem], animated: true)
    }

    @objc
    private func deleteAll() {
        let alertController = UIAlertController(
            title: "Remove All",
            message: "Do you want to remove all items?",
            preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)

        let removeAllAction = UIAlertAction(title: "Remove All", style: .destructive) { [weak self] _ in
            guard let `self` = self else { return }

            let numberOfEntries = self.entry?.numberOfEntries ?? 0
            let indexPaths = (0 ..< numberOfEntries).map { IndexPath(row: $0, section: 0) }.sorted { $0 < $1 }

            self.entry?.removeAllEntries()

            self.tableView.deleteRows(at: indexPaths, with: .automatic)
            self.delegate?.didDelete(viewController: self)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
        }
        alertController.addAction(removeAllAction)

        present(alertController, animated: true)
    }

    private func setupViews() {
        view.addSubview(toolbar)
        NSLayoutConstraint.activate([
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: toolbar.topAnchor)
        ])
    }
}

extension FinishedItemsController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entry?.numberOfEntries ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.backgroundColor = .backgroundColor
        cell.textLabel?.textColor = .textColor
        cell.textLabel?.text = entry?.getEntries()[indexPath.row].name
        return cell
    }
}

extension FinishedItemsController: UITableViewDelegate {
    public func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, sourceView, completionHandler) in
            guard let `self` = self, let entry = self.entry else {
                completionHandler(false)
                return
            }

            let entryToRemove = entry.getEntries()[indexPath.row]
            entry.removeEntry(entryToRemove)

            self.delegate?.didDelete(viewController: self)

            completionHandler(true)
            self.tableView.reloadData()

            if entry.numberOfEntries == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                })
            }
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
