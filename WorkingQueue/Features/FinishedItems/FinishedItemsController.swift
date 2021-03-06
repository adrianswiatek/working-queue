import UIKit
import RxSwift
import RxCocoa

public class FinishedItemsController: UIViewController {

    public var entry: WorkflowEndEntry?

    public var entryObservable: Observable<WorkflowEndEntry> {
        return entrySubject.asObservable().share()
    }

    private let entrySubject = PublishRelay<WorkflowEndEntry>()
    private let disposeBag = DisposeBag()
    private let cellIdentifier = "Cell"

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .backgroundColor
        tableView.isEditing = false
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    public override func viewDidLoad() {
        configureTableView()
        configureToolbar()
        setupEntrySubject()
        setupViews()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(false, animated: true)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setToolbarHidden(true, animated: true)
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

        let toolbarItems = [spaceBarButtonItem, deleteAllBarButtonItem, spaceBarButtonItem]
        setToolbarItems(toolbarItems, animated: true)
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
            guard let `self` = self, var entry = self.entry else { return }

            let numberOfEntries = entry.numberOfEntries
            let indexPaths = (0 ..< numberOfEntries).map { IndexPath(row: $0, section: 0) }.sorted { $0 < $1 }

            entry.removeAllEntries()

            self.entrySubject.accept(entry)
            self.tableView.deleteRows(at: indexPaths, with: .automatic)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
        }
        alertController.addAction(removeAllAction)

        present(alertController, animated: true)
    }

    private func setupEntrySubject() {
        entryObservable.subscribe(onNext: { [weak self] in self?.entry = $0 }).disposed(by: disposeBag)
    }

    private func setupViews() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            guard let `self` = self, var entry = self.entry else {
                completionHandler(false)
                return
            }

            let entryToRemove = entry.getEntries()[indexPath.row]
            entry.removeEntry(entryToRemove)
            self.entrySubject.accept(entry)

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
